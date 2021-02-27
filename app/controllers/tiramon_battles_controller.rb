class TiramonBattlesController < ApplicationController
  before_action :authenticate_user!, only: [:battle]
  before_action :set_tiramon_battle, only: [:show]
  before_action :already_battle, only: [:show]
  before_action :set_tiramon_battle_result, only: [:show]

  def index
    if user_signed_in?
      @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)
      @my_tiramons = Tiramon.where(tiramon_trainer_id: @tiramon_trainer)
      my_battles_red = TiramonBattle.where(red_tiramon_id: @my_tiramons)
      my_battles_blue = TiramonBattle.where(blue_tiramon_id: @my_tiramons)
      @my_battles = TiramonBattle.none.or(my_battles_red).or(my_battles_blue).where("datetime < ?", Time.current).order(datetime: :desc).limit(5)

      @my_free_tiramos_count = @my_tiramons.to_a.select { |t| t.can_act? }.size
    end

    @next_battle = []
    @battles = []

    (0..5).each do |rank|
      @next_battle[rank] = TiramonBattle.where(rank: rank).where("datetime > ?", Time.current).order(datetime: :asc).first
      @battles[rank] = TiramonBattle.where(rank: rank).where("datetime < ?", Time.current).order(datetime: :desc).limit(5)
    end

  end

  def show
    @result = @tiramon_battle.getData
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

    def already_battle
      return @tiramon_battle.datetime < Time.current
    end

    def set_tiramon_battle_result
      if @tiramon_battle.result.blank?
        @tiramon_battle.set_result()
      end
    end
end
