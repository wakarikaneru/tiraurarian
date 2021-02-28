class TiramonBattlesController < ApplicationController
  before_action :authenticate_user!, only: [:battle]
  before_action :set_tiramon_battle, only: [:show, :show_realtime]
  before_action :already_battle, only: [:show, :show_realtime]
  before_action :set_tiramon_battle_result, only: [:show, :show_realtime]

  def index
    if user_signed_in?
      @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)
      @my_tiramons = Tiramon.where(tiramon_trainer_id: @tiramon_trainer)
      my_battles_red = TiramonBattle.where(red_tiramon_id: @my_tiramons)
      my_battles_blue = TiramonBattle.where(blue_tiramon_id: @my_tiramons)
      @my_battles = TiramonBattle.none.or(my_battles_red).or(my_battles_blue).where("datetime < ?", Time.current).order(datetime: :desc).limit(5)

      @my_free_tiramos_count = @my_tiramons.to_a.select { |t| t.can_act? }.size
    end

    @next_battles = []
    @battles = []

    (0..5).each do |rank|
      @next_battles[rank] = TiramonBattle.where(rank: rank).where("datetime > ?", Time.current).order(datetime: :asc)
      @battles[rank] = TiramonBattle.where(rank: rank).where("datetime < ?", Time.current).order(datetime: :desc).limit(5)
    end

  end

  def show
    @result = @tiramon_battle.getData
    if @tiramon_battle.rank == 0
      match_end_time = @tiramon_battle.datetime + @tiramon_battle.match_time.second
      @in_match = Time.current < match_end_time
    else
      @in_match = false
    end
  end

  def show_realtime
    @result = @tiramon_battle.getData
    @result_log = @result[:log]
    @result_realtime_log = []

    start_time = @tiramon_battle.datetime
    time = 0
    before_time = 0
    @result_log.each do |log|
      if log[0] == 4
        before_time = time
        time = log[1].second
      end
      if start_time + before_time < Time.current and Time.current < start_time + time
        @result_realtime_log << log
      end
      if start_time + @tiramon_battle.match_time.second < Time.current
        if time == @tiramon_battle.match_time.second
          @result_realtime_log << log
        end
      end
    end

    render partial: "tiramon_battles/show_realtime"
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
