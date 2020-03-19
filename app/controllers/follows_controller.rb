class FollowsController < ApplicationController
  before_action :set_follow, only: [:destroy]

  # GET /follows
  # GET /follows.json
  def index
    if user_signed_in? then
      @follows = Follow.where(user_id: current_user.id).order(create_datetime: "DESC")
      @followers = Follow.where(target_id: current_user.id).order(create_datetime: "DESC")
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path, alert: 'ログインしてください。' }
        format.json { head :no_content }
      end
    end
  end

  # POST /follows
  # POST /follows.json
  def create
    @follow = Follow.new(follow_params)
    @follow.user_id = current_user.id
    @follow.create_datetime = Time.current

    respond_to do |format|
      if @follow.save
        format.html { redirect_to redirect_back(fallback_location: root_path, notice: "フォローしました。" )}
        format.json { render :show, status: :created, location: @follow }
      else
        format.html { render :new }
        format.json { render json: @follow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /follows/1
  # DELETE /follows/1.json
  def destroy
    if @follow.user_id == current_user.id
      @follow.destroy
      respond_to do |format|
        format.html { redirect_to redirect_back(fallback_location: root_path, notice: "フォローを解除しました。" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to redirect_back(fallback_location: root_path, alert: "権限がありません。" )}
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_follow
      @follow = Follow.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def follow_params
      params.require(:follow).permit(:user_id, :target_id, :create_datetime)
    end
end
