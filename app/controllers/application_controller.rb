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
      access_count = Control.find_or_create_by(key: "access_count")
      access_count.update(value: (access_count.value.to_i + 1).to_s)

      access_log = AccessLog.new
      access_log.access_datetime = Time.current
      access_log.ip_address = request.remote_ip
      access_log.url = request.url
      access_log.method = request.method
      access_log.referer = request.referer
      if user_signed_in?
        access_log.user_id = current_user.id
      else
        access_log.user_id = 0
      end
      access_log.save!
    end

    def get_active_users
      @active_users = User.where(id: AccessLog.where.not(user_id: 0).where("access_datetime > ?", 10.minutes.ago).select(:user_id))
      @active_users_count = @active_users.count
      active_users_ips = AccessLog.where("access_datetime > ?", 10.minutes.ago).where.not(user_id: 0).select(:ip_address)
      @active_anonyms_count = AccessLog.where("access_datetime > ?", 10.minutes.ago).where(user_id: 0).where.not(ip_address: active_users_ips).distinct(:ip_address).select(:ip_address).count
    end

    def create_thumb
      key = Date.today.to_s + ":" + request.remote_ip
      if Thumb.find_by(key: key).present?
      else
        CreateThumbJob.perform_later(key)
      end
    end

end
