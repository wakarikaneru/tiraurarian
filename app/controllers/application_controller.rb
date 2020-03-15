class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :access_log

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
      end
      access_log.save!
    end

end
