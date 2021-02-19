class TiramonsController < ApplicationController
  before_action :set_tiramon, only: [:show]

  def show
    @data = @tiramon.getData
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tiramon
      @tiramon = Tiramon.find(params[:id])
    end
end
