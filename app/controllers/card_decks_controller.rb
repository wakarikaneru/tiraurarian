class CardDecksController < ApplicationController
  before_action :set_card_deck, only: [:show, :edit, :update, :destroy]

  # GET /card_decks
  # GET /card_decks.json
  def index
    @card_decks = CardDeck.all
  end

  # GET /card_decks/1
  # GET /card_decks/1.json
  def show
  end

  # GET /card_decks/new
  def new
    @card_deck = CardDeck.new
  end

  # GET /card_decks/1/edit
  def edit
  end

  # POST /card_decks
  # POST /card_decks.json
  def create
    @card_deck = CardDeck.new(card_deck_params)

    respond_to do |format|
      if @card_deck.save
        format.html { redirect_to @card_deck, notice: 'Card deck was successfully created.' }
        format.json { render :show, status: :created, location: @card_deck }
      else
        format.html { render :new }
        format.json { render json: @card_deck.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /card_decks/1
  # PATCH/PUT /card_decks/1.json
  def update
    respond_to do |format|
      if @card_deck.update(card_deck_params)
        format.html { redirect_to @card_deck, notice: 'Card deck was successfully updated.' }
        format.json { render :show, status: :ok, location: @card_deck }
      else
        format.html { render :edit }
        format.json { render json: @card_deck.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /card_decks/1
  # DELETE /card_decks/1.json
  def destroy
    @card_deck.destroy
    respond_to do |format|
      format.html { redirect_to card_decks_url, notice: 'Card deck was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card_deck
      @card_deck = CardDeck.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_deck_params
      params.require(:card_deck).permit(:user_id, :card_1, :card_2, :card_3, :create_datetime)
    end
end
