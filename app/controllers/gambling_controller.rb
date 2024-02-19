class GamblingController < ApplicationController

  def index
  end

  def gambling
    bet_str = params[:bet]
    color_str = params[:color]

    bet = bet_str.to_i

    if user_signed_in?

      @hofs = GamblingResult.joins(:user).where(game: "gambling").where(result: true).order(point: :desc).order(id: :desc).limit(10).includes(:user)

      if bet_str.present? && color_str.present?

        unless 0 < bet
          redirect_to gambling_gambling_path, notice: "入力が不正です"
          return
        end

        if current_user.sub_points?(bet)

          colors = ["白", "黒", "緑"]
          result = Random.rand(0..1)

          case color_str
            when "white"
              select = 0
            when "black"
              select = 1
            else
              select = 2
          end

          @play_str = "あなたは#{colors[select]}に賭けました。結果は#{colors[result]}でした。"

          if result == select
            outcome = bet * 2
            current_user.add_points(outcome)
            GamblingResult.generate(current_user.id, true, outcome, "gambling")
            @result_str = "あなたの勝ちです！#{outcome}vaを獲得しました！"
          else
            GamblingResult.generate(current_user.id, false, bet, "gambling")
            @result_str = "あなたの負けです！#{bet}vaは没収されました！"
          end

        else
          redirect_to gambling_gambling_path, notice: "VARTHが足りません"
          return
        end

      else
        @play_str = nil
        @result_str = nil
      end

    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path, alert: "ログインしてください。" }
        format.json { head :no_content }
      end
    end
  end

end
