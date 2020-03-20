class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :access_log
  before_action :get_active_users
  before_action :create_thumb

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

    def get_active_users
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
    end

    def create_thumb
      key = Date.today.to_s + ":" + request.remote_ip
      if Thumb.find_by(key: key).present?
      else
        CreateThumbJob.perform_later(key)
      end
    end

end
