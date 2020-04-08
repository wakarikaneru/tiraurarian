class TaxpayersController < ApplicationController

  def index
    @taxpayer_hofs = TaxpayerHof.joins(:user).order(tax: :desc).order(user_id: :asc).limit(5).includes(:user)
    @taxpayers = Taxpayer.joins(:user).order(tax: :desc).order(user_id: :asc).limit(10).includes(:user)
  end

end
