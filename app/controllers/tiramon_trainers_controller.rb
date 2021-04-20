class TiramonTrainersController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)
    @tiramons = Tiramon.where(tiramon_trainer_id: @tiramon_trainer.id)
    @negotiations_tiramons = Tiramon.where(right: @tiramon_trainer.id).where("get_limit > ?", Time.current)

    @select = []
    @tiramons.each do |t|
      d = t.getData
      if 20 <= d[:train][:level]
        @select << ["[" + t.getFactorName + "] " + d[:name], t.id]
      end
    end
  end


  def move_recovery
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)

    if @tiramon_trainer.move_recovery?(current_user)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "行動ポイントを回復しました！" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "行動ポイントを回復できませんでした。" )}
        format.json { head :no_content }
      end
    end
  end

  def get_ball
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)

    if @tiramon_trainer.get_ball?(current_user)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "ボールを入手しました！" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "ボールを入手できませんでした。" )}
        format.json { head :no_content }
      end
    end
  end

end
