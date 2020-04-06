class StocksController < ApplicationController

  def index
    if user_signed_in?
      @stock = Stock.find_or_create_by(user_id: current_user.id)

      @name = Control.find_by(key: "company_name").value
      @price = Control.find_by(key: "stock_price").value.to_i
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path, alert: "ログインしてください。" }
        format.json { head :no_content }
      end
    end
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
