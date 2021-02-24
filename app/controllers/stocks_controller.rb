class StocksController < ApplicationController
  before_action :authenticate_user!, only: [:index, :info, :purchase, :sale]

  def index
    if user_signed_in?
      @stock = Stock.find_or_create_by(user_id: current_user.id)
      @name = Control.find_by(key: "company_name").value

    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path, alert: "ログインしてください。" }
        format.json { head :no_content }
      end
    end
  end

  def info
    @stock = Stock.find_or_create_by(user_id: current_user.id)
    @name = Control.find_by(key: "company_name").value
    @number = Control.find_by(key: "company_count").value
    @price = Control.find_by(key: "stock_price").value.to_i

    economy_f = Control.find_by(key: "stock_economy").value.to_f
    economy_f += Control.find_by(key: "stock_appearance_economy").value.to_f

    if 100 < economy_f
      @economy = "神景気"
    elsif 50 < economy_f
      @economy = "超景気"
    elsif 10 < economy_f
      @economy = "好景気"
    elsif economy_f < -100
      @economy = "世界恐慌"
    elsif economy_f < -50
      @economy = "深刻な不景気"
    elsif economy_f < -10
      @economy = "不景気"
    else
      @economy = "普通"
    end
    render partial: "info"
  end

  def stock_log
    @stock_log = StockLog.where("? <= datetime", 3.hour.ago).order(id: :desc)
    render json: @stock_log.pluck(:datetime, :point)
  end

  def purchase
    num_str = params[:point]
    num = num_str.to_i
    if user_signed_in?
      if Stock.purchase?(current_user, num)
        respond_to do |format|
          format.html { redirect_back(fallback_location: root_path, notice: "#{num}株購入しました。" )}
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_back(fallback_location: root_path, notice: "購入できませんでした。" )}
          format.json { head :no_content }
        end
      end
    end
  end

  def sale
    num_str = params[:point]
    num = num_str.to_i
    if user_signed_in?
      if Stock.sale?(current_user, num)
        respond_to do |format|
          format.html { redirect_back(fallback_location: root_path, notice: "#{num}株売却しました。" )}
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_back(fallback_location: root_path, notice: "売却できませんでした。" )}
          format.json { head :no_content }
        end
      end
    end
  end

end
