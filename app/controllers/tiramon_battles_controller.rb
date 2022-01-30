class TiramonBattlesController < ApplicationController
  before_action :authenticate_user!, only: [:adventure_battle]
  before_action :set_tiramon_battle, only: [:show, :show_realtime]
  before_action :already_battle, only: [:show, :show_realtime]
  before_action :set_tiramon_battle_result, only: [:show, :show_realtime]

  def index
    if user_signed_in?
      @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)
      @my_tiramons = Tiramon.where(tiramon_trainer_id: @tiramon_trainer)
      @negotiations_tiramons = Tiramon.where(right: @tiramon_trainer.id).where("get_limit > ?", Time.current)
      my_battles_red = TiramonBattle.where(red_tiramon_id: @my_tiramons.pluck(:id))
      my_battles_blue = TiramonBattle.where(blue_tiramon_id: @my_tiramons.pluck(:id))
      #@my_battles = TiramonBattle.none.or(my_battles_red).or(my_battles_blue).where.not(rank: -1).where("datetime < ?", Time.current).order(datetime: :desc).limit(5)
      #@my_battles = TiramonBattle.none.or(my_battles_red).or(my_battles_blue).where.not(rank: -1).where("datetime < ?", Time.current).order(datetime: :desc).limit(5)

      @my_free_tiramos_count = @my_tiramons.to_a.select { |t| t.can_act? }.size
    end

    @battles = TiramonBattle.where.not(rank: -1).where("datetime < ?", Time.current).order(datetime: :desc).limit(5)
    @next_battles_present = TiramonBattle.where("datetime > ?", Time.current).order(datetime: :asc).present?
    @next_battles = []

    (0..6).each do |rank|
      @next_battles[rank] = TiramonBattle.where(rank: rank).where("datetime > ?", Time.current).order(datetime: :asc)
    end

    @mania_battle = TiramonBattle.where(rank: 0).where("datetime < ?", Time.current).order(datetime: :desc).first
    @in_match = false
    if @mania_battle.present?
      match_end_time = @mania_battle.datetime + Constants::TIRAMON_ENTRANCE_TIME + @mania_battle.match_time.second
      @in_match = Time.current < match_end_time
    else
      @in_match = false
    end

    if user_signed_in?
      @bet = TiramonBet.where(tiramon_battle: @next_battles[0], user: current_user).first
    end
  end

  def results
    @battles = []

    (0..5).each do |rank|
      @battles[rank] = TiramonBattle.where(rank: rank).where("datetime < ?", Time.current).order(datetime: :desc).limit(20)
    end
  end

  def rank_results
    @battles = TiramonBattle.where(rank: -1).where("datetime < ?", Time.current).order(datetime: :desc).limit(20)
  end

  def adventure_battle
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)

    tiramon_id = params[:tiramon_id]
    enemy_id = params[:enemy_id]

    @tiramon = Tiramon.find_by(id: tiramon_id)

    @result = @tiramon.adventure_battle(@tiramon_trainer, enemy_id)

    if @result.blank?
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "対戦できません。" )}
        format.json { head :no_content }
      end
    end
  end

  def show
    @result = @tiramon_battle.getData
    if @tiramon_battle.rank == 0
      match_end_time = @tiramon_battle.datetime + Constants::TIRAMON_ENTRANCE_TIME + @tiramon_battle.match_time.second
      @in_match = Time.current < match_end_time
    else
      @in_match = false
    end
  end

  def show_realtime
    @result = @tiramon_battle.getData
    @result_log = @result[:log]
    @result_realtime_log = []

    start_time = @tiramon_battle.datetime + Constants::TIRAMON_ENTRANCE_TIME
    match_now_time = Time.current - start_time
    if match_now_time < 0
      @in_progress = "試合開始前"
    else
      @in_progress = "試合時間: " + Time.at(match_now_time).utc.strftime("%M分%S秒")
    end

    time = -1.day
    before_time = -1.day
    @result_log.each do |log|
      if log[0] == 4
        before_time = time
        time = log[1].second
      end
      if start_time + before_time <= Time.current and Time.current < start_time + time
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
