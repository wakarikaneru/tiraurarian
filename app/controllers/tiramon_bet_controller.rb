class TiramonBetController < ApplicationController
  before_action :authenticate_user!, only: [:bet]

  def bet
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)

    bet = params[:bet].to_i
    point = params[:point].to_i

    if TiramonBet.bet(current_user, bet, point)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "ベットしました！" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "ベットできませんでした。" )}
        format.json { head :no_content }
      end
    end
  end

end
