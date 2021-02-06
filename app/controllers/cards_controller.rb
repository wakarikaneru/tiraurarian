class CardsController < ApplicationController
  before_action :set_card, only: [:destroy]
  before_action :get_used_cards, only: [:index, :destroy]

  # GET /cards
  # GET /cards.json
  def index
    if user_signed_in?
      @box = CardBox.find_or_create_by(user_id: current_user.id)
      @cards = Card.where(card_box_id: @box.id).order(:element).order(power: :desc)
      @count = Card.where(card_box_id: @box.id).count

    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path, alert: "ログインしてください。" }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    if !@card.in?(@used_cards)
      @card.destroy
      respond_to do |format|
        format.html { redirect_to cards_url, notice: 'カードを削除しました' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to cards_url, alert: "カードは使用中です" }
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
