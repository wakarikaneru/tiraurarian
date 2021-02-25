class TiramonBattlesController < ApplicationController
  before_action :authenticate_user!, only: [:battle]
  before_action :set_tiramon_battle, only: [:show]

  def index
    if user_signed_in?
      @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)
      @my_tiramos = Tiramon.where(tiramon_trainer_id: @tiramon_trainer)
      my_battles_red = TiramonBattle.where(red_tiramon_id: @my_tiramos)
      my_battles_blue = TiramonBattle.where(blue_tiramon_id: @my_tiramos)
      @my_battles = TiramonBattle.none.or(my_battles_red).or(my_battles_blue).where("datetime < ?", Time.current).order(datetime: :desc).limit(5)

      @my_free_tiramos = Tiramon.where(tiramon_trainer_id: @tiramon_trainer).where("act < ?", Time.current)
    end

    @next_battle = []
    @battles = []

    (0..4).each do |rank|
      @next_battle[rank] = TiramonBattle.where(rank: rank).where("datetime > ?", Time.current).order(datetime: :asc).first
      @battles[rank] = TiramonBattle.where(rank: rank).where("datetime < ?", Time.current).order(datetime: :desc).limit(5)
    end

  end

  def show
    @result = @tiramon_battle.getData
    if @tiramon_battle.datetime < Time.current
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: tiramon_battles_path, notice: "まだ試合は行われていません。" )}
        format.json { head :no_content }
      end
    end
  end

  def battle
    tiramons = Tiramon.all.sample(2)
    tiramon_1 = tiramons[0]
    tiramon_2 = tiramons[1]
    @result = Tiramon.battle(tiramon_1, tiramon_2)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tiramon_battle
      @tiramon_battle = TiramonBattle.find(params[:id])
    end
end
