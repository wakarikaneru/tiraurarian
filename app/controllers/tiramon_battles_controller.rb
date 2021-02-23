class TiramonBattlesController < ApplicationController
  before_action :set_tiramon_battle, only: [:show]

  def index
    @next_battle = TiramonBattle.where("datetime > ?", Time.current).order(datetime: :asc).first
    @battles = TiramonBattle.where("datetime < ?", Time.current).order(id: :desc).limit(10)
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
