class MutesController < ApplicationController
  before_action :set_mute, only: [:destroy]

  # GET /mutes
  # GET /mutes.json
  def index
    if user_signed_in? then
      @mutes = Mute.where(user_id: current_user.id).order(id: "DESC")
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path, alert: 'ログインしてください。' }
        format.json { head :no_content }
      end
    end
  end

  # POST /mutes
  # POST /mutes.json
  def create
    @mute = Mute.new(mute_params)
    @mute.user_id = current_user.id
    @mute.create_datetime = Time.current

    respond_to do |format|
      if @mute.save
        format.html { redirect_to :back, notice: 'ミュートしました。' }
        format.json { render :show, status: :created, location: @mute }
      else
        format.html { render :new }
        format.json { render json: @mute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mutes/1
  # DELETE /mutes/1.json
  def destroy
    if @mute.user_id == current_user.id
      @mute.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: 'ミュートを解除しました。' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, alert: "権限がありません。" }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mute
      @mute = Mute.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mute_params
      params.require(:mute).permit(:user_id, :target_id, :create_datetime)
    end
end
