class CardBoxesController < ApplicationController
  before_action :set_card_box, only: [:show, :edit, :update, :destroy]

  # GET /card_boxes
  # GET /card_boxes.json
  def index
    @card_boxes = CardBox.all
  end

  # GET /card_boxes/1
  # GET /card_boxes/1.json
  def show
  end

  # GET /card_boxes/new
  def new
    @card_box = CardBox.new
  end

  # GET /card_boxes/1/edit
  def edit
  end

  # POST /card_boxes
  # POST /card_boxes.json
  def create
    @card_box = CardBox.new(card_box_params)

    respond_to do |format|
      if @card_box.save
        format.html { redirect_to @card_box, notice: 'Card box was successfully created.' }
        format.json { render :show, status: :created, location: @card_box }
      else
        format.html { render :new }
        format.json { render json: @card_box.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /card_boxes/1
  # PATCH/PUT /card_boxes/1.json
  def update
    respond_to do |format|
      if @card_box.update(card_box_params)
        format.html { redirect_to @card_box, notice: 'Card box was successfully updated.' }
        format.json { render :show, status: :ok, location: @card_box }
      else
        format.html { render :edit }
        format.json { render json: @card_box.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /card_boxes/1
  # DELETE /card_boxes/1.json
  def destroy
    @card_box.destroy
    respond_to do |format|
      format.html { redirect_to card_boxes_url, notice: 'Card box was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card_box
      @card_box = CardBox.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_box_params
      params.require(:card_box).permit(:user_id, :size, :create_datetime)
    end
end
