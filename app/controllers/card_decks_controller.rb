class CardDecksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_card_deck, only: [:destroy]
  before_action :set_card, only: [:new, :create]

  # GET /card_decks
  # GET /card_decks.json
  def index
    @card_box = CardBox.find_or_create_by(user_id: current_user.id)
    @card_decks = CardDeck.where(card_box_id: @card_box);
  end

  # GET /card_decks/new
  def new
    @card_box = CardBox.find_or_create_by(user_id: current_user.id)
    @card_deck = CardDeck.new
  end

  # POST /card_decks
  # POST /card_decks.json
  def create
    @card_deck = CardDeck.new(card_deck_params)

    if user_signed_in? then
      card_box = CardBox.find_or_create_by(user_id: current_user.id)
      @card_deck.card_box_id = card_box.id

      respond_to do |format|
        if @card_deck.save
          format.html { redirect_to card_decks_url, notice: "デッキを作成しました。" }
          format.json { render :show, status: :created, location: @card_deck }
        else
          format.html { render :new }
          format.json { render json: @card_deck.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /card_decks/1
  # DELETE /card_decks/1.json
  def destroy
    if !@card_deck.isKing?
      @card_deck.destroy
      respond_to do |format|
        format.html { redirect_to card_decks_url, notice: 'デッキを解体しました。' }
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
    def set_card_deck
      @card_deck = CardDeck.find(params[:id])
    end

    def set_card
      card_box = CardBox.find_or_create_by(user_id: current_user.id)

      my_deck = CardDeck.where(card_box_id: card_box);
      used_card_1 = Card.where(id: my_deck.select(:card_1_id))
      used_card_2 = Card.where(id: my_deck.select(:card_2_id))
      used_card_3 = Card.where(id: my_deck.select(:card_3_id))
      used_card = Card.none.or(used_card_1).or(used_card_2).or(used_card_3)

      @cards = Card.where(card_box_id: card_box.id).where.not(id: used_card).order(:element).order(power: :desc)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_deck_params
      params.require(:card_deck).permit(:card_box_id, :card_1_id, :card_2_id, :card_3_id, :create_datetime)
    end
end
