class TiramonBattlesController < ApplicationController
  before_action :authenticate_user!, only: [:battle]
  before_action :set_tiramon_battle, only: [:show]

  def index
    if user_signed_in?
      @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)
      @my_tiramos = Tiramon.where(tiramon_trainer_id: @tiramon_trainer)
      my_battles_red = TiramonBattle.where(red_tiramon_id: @my_tiramos)
      my_battles_blue = TiramonBattle.where(red_tiramon_id: @my_tiramos)
      @my_battles = TiramonBattle.none.or(my_battles_red).or(my_battles_blue).where("datetime < ?", Time.current).order(datetime: :desc).limit(5)
    end

    @next_battle = []
    @battles = []

    @next_battle[0] = TiramonBattle.where(rank: 0).where("datetime > ?", Time.current).order(datetime: :asc).first
    @battles[0] = TiramonBattle.where(rank: 0).where("datetime < ?", Time.current).order(datetime: :desc).limit(5)

    @next_battle[1] = TiramonBattle.where(rank: 1).where("datetime > ?", Time.current).order(datetime: :asc).first
    @battles[1] = TiramonBattle.where(rank: 1).where("datetime < ?", Time.current).order(datetime: :desc).limit(5)

    @next_battle[2] = TiramonBattle.where(rank: 2).where("datetime > ?", Time.current).order(datetime: :asc).first
    @battles[2] = TiramonBattle.where(rank: 2).where("datetime < ?", Time.current).order(datetime: :desc).limit(5)

    @next_battle[3] = TiramonBattle.where(rank: 3).where("datetime > ?", Time.current).order(datetime: :asc).first
    @battles[3] = TiramonBattle.where(rank: 3).where("datetime < ?", Time.current).order(datetime: :desc).limit(5)

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
