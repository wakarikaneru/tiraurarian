class CardsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :dumpsite, :dump, :select_send_card, :send_card, :destroy]
  before_action :set_card, only: [:send_card, :destroy]
  before_action :get_used_cards, only: [:index, :dumpsite, :dump, :select_send_card, :send_card, :destroy]

  # GET /cards
  # GET /cards.json
  def index
    @box = CardBox.find_or_create_by(user_id: current_user.id)
    @cards = Card.where(card_box_id: @box.id).order(:element).order(power: :desc)
    @count = Card.where(card_box_id: @box.id).count
  end

  def dumpsite
    @box = CardBox.find_or_create_by(user_id: current_user.id)
    @cards = Card.where(card_box_id: @box.id).order(:element).order(power: :desc)
    @count = Card.where(card_box_id: @box.id).count
  end

  def dump
    cards = params[:cards]
    @total = cards.size
    @count_success = 0
    @count_fail = 0
    cards.each{|card_id|
      card = Card.find_by(id: card_id)
      if card.present?
        if card.card_box.user == current_user
          if !card.in?(@used_cards)
            card.destroy
            @count_success += 1
            next
          end
        end
      end
      @count_fail += 1
    }
    if @count_fail == 0
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: @count_success.to_s + "枚のカードを削除しました。" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: @count_success.to_s + "枚のカードを削除しました。 " + @count_fail.to_s + "枚のカードは削除できませんでした。" )}
        format.json { head :no_content }
      end
    end
  end

  def select_send_card
    @box = CardBox.find_or_create_by(user_id: current_user.id)
    @user = User.find_by(id: params[:user_id])

    if @user.present?
      cards = Card.where(card_box_id: @box.id).order(:element).order(power: :desc)
      @sendable_cards = cards.where.not(id: @used_cards)
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "ユーザーが存在しません。" )}
        format.json { head :no_content }
      end
    end
  end

  def send_card
    @user = User.find_by(id: params[:user_id])
    if @card.card_box.user == current_user
      if !@card.in?(@used_cards)
        if @card.send?(current_user, @user)
          Notice.generate(current_user.id, @user.id, @user.name, "カード[" + @card.displayNameWithAbility + "]を送信しました。")
          Notice.generate(@user.id, current_user.id, current_user.name, "カード[" + @card.displayNameWithAbility + "]を受け取りました。")
          respond_to do |format|
            format.html { redirect_back(fallback_location: root_path, notice: @user.name + "にカード[" + @card.displayNameWithAbility + "]を送信しました。" )}
            format.json { head :no_content }
          end
        else
          respond_to do |format|
            format.html { redirect_back(fallback_location: root_path, alert: "カードを送信できませんでした。" )}
            format.json { head :no_content }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to cards_url, alert: "カードは使用中です。" }
          format.json { head :no_content }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to cards_url, alert: "自分のカードではありません。" }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    if @card.card_box.user == current_user
      if !@card.in?(@used_cards)
        @card.destroy
        respond_to do |format|
          format.html { redirect_to cards_url, notice: 'カードを削除しました。' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to cards_url, alert: "カードは使用中です。" }
          format.json { head :no_content }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to cards_url, alert: "自分のカードではありません。" }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:id])
    end

    def get_used_cards
      card_box = CardBox.find_or_create_by(user_id: current_user.id)

      my_deck = CardDeck.where(card_box_id: card_box);
      used_card_1 = Card.where(id: my_deck.select(:card_1_id))
      used_card_2 = Card.where(id: my_deck.select(:card_2_id))
      used_card_3 = Card.where(id: my_deck.select(:card_3_id))

      @used_cards = Card.none.or(used_card_1).or(used_card_2).or(used_card_3)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_params
      params.require(:card).permit(:user_id, :model_id, :type, :power, :create_datetime)
    end
end
