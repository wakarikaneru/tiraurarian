class PointsController < ApplicationController
  before_action :set_point, only: [:destroy]

  # GET /points
  # GET /points.json
  def index
    @points = Point.all
  end

  # DELETE /points/1
  # DELETE /points/1.json
  def destroy
    @point.destroy
    respond_to do |format|
      format.html { redirect_to points_url, notice: 'Point was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def remit
    point_str = params[:point]
    user_id_str = params[:user_id]

    if user_signed_in?
      if point_str.blank?
        respond_to do |format|
          format.html { redirect_to :back, error: 'ポイントを入力してください。' }
          format.json { head :no_content }
        end
      elsif user_id_str.blank?
        respond_to do |format|
          format.html { redirect_to :back, error: 'ユーザーを指定してください。' }
          format.json { head :no_content }
        end
      else
        match_point = point_str =~ /^[1-9][0-9]*$/

        if match_point.nil?
          respond_to do |format|
            format.html { redirect_to :back, error: '入力が不正です。' }
            format.json { head :no_content }
          end
        else
          user = User.find(user_id_str.to_i)
          point = point_str.to_i

          if user.present?
            if current_user.send_points?(user, point)
              respond_to do |format|
                format.html { redirect_to :back, notice: '#{point}VARTHを送信しました。' }
                format.json { head :no_content }
              end
            else
              respond_to do |format|
                format.html { redirect_to :back, error: 'VARTHの送信に失敗しました。' }
                format.json { head :no_content }
              end
            end
          else
            respond_to do |format|
              format.html { redirect_to :back, error: 'ユーザーが存在しません。' }
              format.json { head :no_content }
            end
          end
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, error: 'ログインしてください。' }
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
