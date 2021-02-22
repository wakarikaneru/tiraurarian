class TiramonsController < ApplicationController
  before_action :set_tiramon, only: [:show]

  def index
    @tiramons = Tiramon.where(user_id: current_user)
  end

  def get
    @data = Tiramon.generateData(25)
    @disp_data = Tiramon.getBattleData(@data)
    @json = @data.to_json
  end

  def show
    @data = @tiramon.getData
    @disp_data = @tiramon.getData2
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tiramon
      @tiramon = Tiramon.find(params[:id])
    end
end
