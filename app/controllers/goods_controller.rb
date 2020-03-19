class GoodsController < ApplicationController
  before_action :set_good, only: [:destroy]

  # GET /goods
  # GET /goods.json
  def index
    @goods = Good.where(user_id: current_user.id).order(id: "DESC")
  end

  # GET /goods/1
  # GET /goods/1.json
  def show
  end

  # POST /goods
  # POST /goods.json
  def create
    @good = Good.new(good_params)
    @good.user_id = current_user.id
    @good.create_datetime = Time.current

    respond_to do |format|
      if @good.save
        format.html { redirect_back(fallback_location: root_path, notice: "Goodをつけました。" )}
        format.json { render :show, status: :created, location: @good }
      else
        format.html { render :new }
        format.json { render json: @good.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goods/1
  # DELETE /goods/1.json
  def destroy
    if @good.user_id == current_user.id
      @good.destroy
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "Goodを解除しました。" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "権限がありません。" )}
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_good
      @good = Good.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def good_params
      params.require(:good).permit(:tweet_id, :user_id, :create_datetime)
    end
end
