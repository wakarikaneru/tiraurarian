class AdministrationController < ApplicationController
  before_action :authenticate_user!
  before_action :administrator!

  protected
    def administrator!
      admin = Admin.where(user_id: current_user.id)

      if 1 <= admin.size
      else
        redirect_to root_path
      end
    end
end
