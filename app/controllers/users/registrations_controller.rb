class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.

  private
    def check_captcha
      unless Rails.env == 'development'
        unless verify_recaptcha(action: 'registration', minimum_score: 0.0)
          self.resource = resource_class.new sign_up_params
          resource.validate # Look for any other validation errors besides Recaptcha
          set_minimum_password_length
          respond_with_navigational(resource) { render :new }
        end
      end
    end
end
