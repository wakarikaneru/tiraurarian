class TiramonsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :get, :training, :show]
  before_action :set_tiramon, only: [:show, :get, :training]

  def index
    @tiramons = Tiramon.where(user_id: current_user)
  end

  def scout
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)
    if @tiramon_trainer.move?
      @tiramon = Tiramon.generate(@tiramon_trainer, 5, 15)
      @data = @tiramon.getData
      @disp_data = Tiramon.getBattleData(@data)
      @about = [(100 - @tiramon_trainer.level) / 10, 10, 1].sort.second

      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "チラモンを発見しました！" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "行動ポイントが足りません。" )}
        format.json { head :no_content }
      end
    end
  end

  def get
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)
    if @tiramon.get?(@tiramon_trainer)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "ゲットしました！" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "ゲットできませんでした。" )}
        format.json { head :no_content }
      end
    end
  end

  def training
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)
    training = params[:training].to_i
    if @tiramon.training?(@tiramon_trainer, training)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "育成しました！" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "育成できませんでした。" )}
        format.json { head :no_content }
      end
    end
  end

  def show
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)
    @data = @tiramon.getData
    @disp_data = Tiramon.getBattleData(@data)

    @my_tiramon = @tiramon.tiramon_trainer_id == @tiramon_trainer.id
    if @my_tiramon
      @about = 1
    else
      @about = [(100 - @tiramon_trainer.level) / 10, 10, 1].sort.second
    end

    if @tiramon.act.present?
      @can_act = @tiramon.act < Time.current
    else
      @can_act = true
    end

    @training = @tiramon.getTrainingText
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tiramon
      @tiramon = Tiramon.find(params[:id])
    end
end
