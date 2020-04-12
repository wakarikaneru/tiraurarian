class PremiumController < ApplicationController

  def index
  end

  def create
    unless @is_premium

      if current_user.sub_points?(Constants::PREMIUM_PRICE)
        Premium.generate(current_user.id)
        redirect_to premium_path, notice: "プレミアム会員になりました。"
      else
        redirect_to premium_path, alert: "VARTHが足りません。"
      end

    else
      redirect_to premium_path, alert: "すでにプレミアム会員です。"
    end

  end

end
