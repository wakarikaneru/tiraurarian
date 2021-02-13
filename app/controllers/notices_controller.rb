class NoticesController < ApplicationController
  before_action :set_notice, only: [:show, :destroy]
  prepend_before_action :set_read, only: [:index]

  # GET /notices
  # GET /notices.json
  def index
    @notices = Notice.none

    if user_signed_in? then
      my_mutes = Mute.where(user_id: current_user.id).select(:target_id)
      receive_notices = Notice.where(user_id: current_user.id)

      notices = Notice.none.or(receive_notices)
      @notices = Notice.none.or(notices).where("create_datetime > ?", Constants::NOTICE_RETENTION_PERIOD.ago).order(create_datetime: :desc)

    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path, alert: 'ログインしてください。' }
        format.json { head :no_content }
      end
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
        format.html { redirect_to notices_url, notice: '通知を削除しました。' }
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
    def set_notice
      @notice = Notice.find(params[:id])
    end

    def set_read
      my_mutes = Mute.where(user_id: current_user.id).select(:target_id)
      receive_notices = Notice.where(user_id: current_user.id)

      notices = Notice.none.or(receive_notices)
      notices.update(read_flag: true)
    end
end
