class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :detect_locale
  before_action :access_log
  before_action :create_thumb

  def detect_locale
    acceptLanguage = request.headers['Accept-Language']
    unless acceptLanguage.nil?
      I18n.locale = acceptLanguage.scan(/\A[a-z]{2}/).first
    end
  end

  def notification
    render json: @notification
  end

  def stat
    stat = Stat.order(id: :desc).limit(60)
    stats = []
    stat.map do |s|
      stats.push({datetime: s.datetime.to_s, load: s.load, users: s.users})
    end
    render json: stats
  end

  def offline
  end

  def load
    stat = Stat.order(id: :desc).first
    @load = stat.load
    case @load
      when 0..200
        @load_str = "低負荷"
      when 201..400
        @load_str = "中負荷"
      when 401..600
        @load_str = "高負荷"
      when 601..800
        @load_str = "超負荷"
      when 801..1000
        @load_str = "やばい"
      else
        @load_str = "未知の領域"
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

end
