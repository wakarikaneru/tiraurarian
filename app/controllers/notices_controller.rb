class NoticesController < ApplicationController
  before_action :set_notice, only: [:show, :destroy]

  # GET /notices
  # GET /notices.json
  def index
    @notices = Notice.none

    if user_signed_in? then
      receive_notices = Notice.where(user_id: current_user.id)
      notices = Notice.none.or(receive_notices)
      @notices = Notice.none.or(notices).where("create_datetime > ?", 7.days.ago).order(create_datetime: :desc)

      @notices.update(read_flag: true)
    else
      redirect_to new_user_session_path
    end
  end

  # GET /notices/1
  # GET /notices/1.json
  def show
  end

  # DELETE /notices/1
  # DELETE /notices/1.json
  def destroy
    if @notice.user_id == current_user.id || @notice.sender_id == current_user.id
      @notice.destroy
      respond_to do |format|
        format.html { redirect_to notices_url, notice: 'Notice was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, alert: "You don't have permission." }
        format.json { head :no_content }
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notice
      @notice = Notice.find(params[:id])
    end

end
