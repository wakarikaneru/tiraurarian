class TaxpayersController < ApplicationController

  def index
    @taxpayers = Taxpayer.joins(:user).order(tax: :desc).order(user_id: :asc).limit(10).includes(:user)
  end

end
