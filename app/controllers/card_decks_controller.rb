class CardDecksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_card_deck, only: [:destroy]
  before_action :set_card, only: [:new, :create, :creater]

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

  def creater
    @card_box = CardBox.find_or_create_by(user_id: current_user.id)
    @card_deck = CardDeck.new
    @card_lists = Array.new(11).map{Array.new()}

    @cards.each{|card|
      @card_lists[card.element].push(card)
    }

    @card_1 = Card.find_by(id: params[:card_1])
    @card_2 = Card.find_by(id: params[:card_2])
    @card_3 = Card.find_by(id: params[:card_3])

    @card_1_w = Card.where(id: params[:card_1])
    @card_2_w = Card.where(id: params[:card_2])
    @card_3_w = Card.where(id: params[:card_3])

    @disabled_cards = @used_cards.or(@card_1_w).or(@card_2_w).or(@card_3_w)

    @card_power_total = 0
    if @card_1.present?
      @card_power_total += @card_1.power
    end
    if @card_2.present?
      @card_power_total += @card_2.power
    end
    if @card_3.present?
      @card_power_total += @card_3.power
    end

    if params[:complete]
      @card_deck.card_1 = @card_1
      @card_deck.card_2 = @card_2
      @card_deck.card_3 = @card_3

      card_box = CardBox.find_or_create_by(user_id: current_user.id)
      @card_deck.card_box_id = card_box.id
      @card_deck.create_datetime = Time.current

      if !@card_deck.card_1.in?(@used_cards) and !@card_deck.card_2.in?(@used_cards) and !@card_deck.card_3.in?(@used_cards)
        respond_to do |format|
          if @card_deck.save
            format.html { redirect_to card_decks_url, notice: "デッキを作成しました。" }
            format.json { render :show, status: :created, location: @card_deck }
          else
            format.html { redirect_back(fallback_location: root_path, alert: "デッキを作成できませんでした。" )}
            format.json { head :no_content }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_back(fallback_location: root_path, alert: "デッキを作成できませんでした。" )}
          format.json { head :no_content }
        end
      end
    end
  end

  # POST /card_decks
  # POST /card_decks.json
  def create
    @card_deck = CardDeck.new(card_deck_params)

    if user_signed_in? then
      card_box = CardBox.find_or_create_by(user_id: current_user.id)
      @card_deck.card_box_id = card_box.id

      if !@card_deck.card_1.in?(@used_cards) and !@card_deck.card_2.in?(@used_cards) and !@card_deck.card_3.in?(@used_cards)
        respond_to do |format|
          if @card_deck.save
            format.html { redirect_to card_decks_url, notice: "デッキを作成しました。" }
            format.json { render :show, status: :created, location: @card_deck }
          else
            format.html { redirect_back(fallback_location: root_path, alert: "デッキを作成できませんでした。" )}
            format.json { head :no_content }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_back(fallback_location: root_path, alert: "デッキを作成できませんでした。" )}
          format.json { head :no_content }
        end
      end
    end
  end

  # DELETE /card_decks/1
  # DELETE /card_decks/1.json
  def destroy
    if @card_deck.card_box.user == current_user
      if !@card_deck.isKing?
        @card_deck.destroy
        respond_to do |format|
          format.html { redirect_to card_decks_url, notice: 'デッキを解体しました。' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to cards_url, alert: "デッキは使用中です。" }
          format.json { head :no_content }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to cards_url, alert: "自分のデッキではありません。" }
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

      @used_cards = Card.none.or(used_card_1).or(used_card_2).or(used_card_3)
      @cards = Card.where(card_box_id: card_box.id).where.not(id: @used_cards).order(:element).order(power: :desc)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_deck_params
      params.require(:card_deck).permit(:card_box_id, :card_1_id, :card_2_id, :card_3_id, :create_datetime)
    end
end
