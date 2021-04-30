class TestsController < ApplicationController
  before_action :authenticate_admin!

  def tests
  end

  def test1
  end

  def authenticate_admin!
    # TODO Add authentication logic here.
    if user_signed_in? && current_user.id == 1
    else
      redirect_to root_path
    end
  end
end
