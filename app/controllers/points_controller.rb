class PointsController < ApplicationController
  before_action :set_point, only: [:destroy]

  # GET /points
  # GET /points.json
  def index
    @points = Point.all
  end

  def remit
    point_str = params[:point]
    user_id_str = params[:user_id]

    if user_signed_in?
      if point_str.blank?
        respond_to do |format|
          format.html { redirect_to :back, alert: "ポイントを入力してください。" }
          format.json { head :no_content }
        end
      elsif user_id_str.blank?
        respond_to do |format|
          format.html { redirect_to :back, alert: "ユーザーを指定してください。" }
          format.json { head :no_content }
        end
      else
        match_point = point_str =~ /^[1-9][0-9]*$/

        if match_point.nil?
          respond_to do |format|
            format.html { redirect_to :back, alert: "入力が不正です。" }
            format.json { head :no_content }
          end
        else
          user = User.find_by(id: user_id_str.to_i)
          point = point_str.to_i

          if user.present?
            if current_user.send_points?(user, point)
              Notice.generate(current_user.id, user.id, user.name, "#{point}VARTHを送信しました。")
              Notice.generate(user.id, current_user.id, current_user.name, "#{point}VARTHを受け取りました。")
              respond_to do |format|
                format.html { redirect_to :back, notice: "#{point}VARTHを送信しました。" }
                format.json { head :no_content }
              end
            else
              respond_to do |format|
                format.html { redirect_to :back, alert: "VARTHの送信に失敗しました。" }
                format.json { head :no_content }
              end
            end
          else
            respond_to do |format|
              format.html { redirect_to :back, alert: "ユーザーが存在しません。" }
              format.json { head :no_content }
            end
          end
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path, alert: "ログインしてください。" }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_point
      @point = Point.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def point_params
      params.require(:point).permit(:user_id, :point)
    end
end
