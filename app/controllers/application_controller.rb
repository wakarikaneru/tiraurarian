class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :detect_locale
  before_action :set_locale
  before_action :access_log
  before_action :notification_count
  before_action :create_thumb

  def detect_locale
    if params[:locale].blank?
      I18n.locale = request.headers['Accept-Language'].scan(/\A[a-z]{2}/).first
      redirect_to root_path
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def notification
    render json: @notification
  end

  def stat
    load = AccessLog.where("access_datetime > ?", 10.minutes.ago).count
    active_users = AccessLog.where("access_datetime > ?", 10.minutes.ago).select(:ip_address).distinct.count
    @stat = {datetime: Time.current.to_s, load: load, users: active_users}
    render json: @stat
  end

  def offline
  end

  def load
    @load = AccessLog.where("access_datetime > ?", 10.minutes.ago).count
    case @load
      when 0..200
        @load_str = "低負荷"
      when 201..400
        @load_str = "中負荷"
      when 401..600
        @load_str = "高負荷"
      when 601..800
        @load_str = "やばい"
      else
        @load_str = "サーバーがあぶない"
    end
    render partial: "layouts/load"
  end

  def active_users
    @active_users = User.none
    @active_anonyms_count = 0
    @active_users_count = @active_users.count
    @active_total_count = @active_users_count + @active_anonyms_count
    render partial: "layouts/active_users"
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:login_id, :name, :avatar, :description])
      devise_parameter_sanitizer.permit(:account_update, keys: [:login_id, :name, :avatar, :description])
    end

    def access_log
      if user_signed_in?
        user_id = current_user.id
      else
        user_id = 0
      end
      AccessLogJob.perform_later(Time.current.to_s, request.remote_ip, request.url, request.method, request.referer, user_id)
    end

    def create_thumb
      key = Date.today.to_s + ":" + request.remote_ip
      if Thumb.find_by(key: key).present?
      else
        CreateThumbJob.perform_later(key)
      end
    end

    def notification_count
      if user_signed_in? then
        notice_records = Notice.where(user_id: current_user.id, read_flag: false).where("create_datetime > ?", Constants::NOTICE_RETENTION_PERIOD.ago)
        message_records = Message.where(user_id: current_user.id, read_flag: false).where("create_datetime > ?", Constants::MESSAGE_RETENTION_PERIOD.ago)
      else
        notice_records = Notice.none
        message_records = Message.none
      end

      @notice_count = notice_records.count
      @message_count = message_records.count
      @total_count = @notice_count + @message_count

      @notification = {datetime: Time.current.to_s, notice: @notice_count, message: @message_count, total: @total_count}
    end

end
