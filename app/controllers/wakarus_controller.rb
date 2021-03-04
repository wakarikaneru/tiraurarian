class WakarusController < ApplicationController
  before_action :set_wakaru, only: %i[ destroy ]

  # GET /wakarus or /wakarus.json
  def index
    @wakarus = Wakaru.where(user_id: current_user.id).order(id: "DESC")
  end

  # GET /wakarus/1 or /wakarus/1.json
  def show
  end

  # POST /wakarus or /wakarus.json
  def create
    @wakaru = Wakaru.new(wakaru_params)
    @wakaru.user_id = current_user.id
    @wakaru.create_datetime = Time.current

    respond_to do |format|
      if @wakaru.save
        format.html { redirect_back(fallback_location: root_path, notice: "わかりました。" )}
        format.json { render :show, status: :created, location: @wakaru }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @wakaru.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wakarus/1 or /wakarus/1.json
  def destroy
    if @wakaru.user_id == current_user.id
      @wakaru.destroy
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "わからなくなりました。" )}
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
    def set_wakaru
      @wakaru = Wakaru.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def wakaru_params
      params.require(:wakaru).permit(:tweet_id, :user_id, :create_datetime)
    end
end
