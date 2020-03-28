class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :access_log
  before_action :notification_count
  before_action :create_thumb

  def notification
    render json: @notification
  end

  def stat
    load = AccessLog.where("access_datetime > ?", 10.minutes.ago).count
    active_users = AccessLog.where("access_datetime > ?", 10.minutes.ago).select(:ip_address).distinct.count
    @stat = {datetime: Time.current.to_s, load: load, active_users: active_users}
    render json: @stat
  end

  def offline
  end

  def active_users
    if user_signed_in?
      @active_users = User.where(id: current_user.id) + User.where("access_datetime > ?", 10.minutes.ago).where.not(id: current_user.id).where.not(id: 0).joins(:access_logs).order("access_logs.id desc").distinct
      active_users_ips = AccessLog.where("access_datetime > ?", 10.minutes.ago).where.not(user_id: 0).select(:ip_address).distinct
      @active_anonyms_count = AccessLog.where("access_datetime > ?", 10.minutes.ago).where(user_id: 0).where.not(ip_address: request.remote_ip).where.not(ip_address: active_users_ips).select(:ip_address).distinct.count
    else
      @active_users = User.joins(:access_logs).where("access_datetime > ?", 10.minutes.ago).where.not(id: 0).order("access_logs.id desc").distinct
      active_users_ips = AccessLog.where("access_datetime > ?", 10.minutes.ago).where.not(user_id: 0).select(:ip_address)
      @active_anonyms_count = 1 + AccessLog.where("access_datetime > ?", 10.minutes.ago).where(user_id: 0).where.not(ip_address: request.remote_ip).where.not(ip_address: active_users_ips).select(:ip_address).distinct.count
    end
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
