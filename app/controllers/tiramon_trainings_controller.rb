class TiramonTrainingsController < ApplicationController
  before_action :set_tiramon_training, only: %i[ show edit update destroy ]

  # GET /tiramon_trainings or /tiramon_trainings.json
  def index
    @tiramon_trainings = TiramonTraining.all
  end

  # GET /tiramon_trainings/1 or /tiramon_trainings/1.json
  def show
  end

  # GET /tiramon_trainings/new
  def new
    @tiramon_training = TiramonTraining.new
  end

  # GET /tiramon_trainings/1/edit
  def edit
  end

  # POST /tiramon_trainings or /tiramon_trainings.json
  def create
    @tiramon_training = TiramonTraining.new(tiramon_training_params)

    respond_to do |format|
      if @tiramon_training.save
        format.html { redirect_to @tiramon_training, notice: "Tiramon training was successfully created." }
        format.json { render :show, status: :created, location: @tiramon_training }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tiramon_training.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tiramon_trainings/1 or /tiramon_trainings/1.json
  def update
    respond_to do |format|
      if @tiramon_training.update(tiramon_training_params)
        format.html { redirect_to @tiramon_training, notice: "Tiramon training was successfully updated." }
        format.json { render :show, status: :ok, location: @tiramon_training }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tiramon_training.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tiramon_trainings/1 or /tiramon_trainings/1.json
  def destroy
    @tiramon_training.destroy
    respond_to do |format|
      format.html { redirect_to tiramon_trainings_url, notice: "Tiramon training was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tiramon_training
      @tiramon_training = TiramonTraining.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tiramon_training_params
      params.require(:tiramon_training).permit(:level, :training)
    end
end
