class BadsController < ApplicationController
  before_action :set_bad, only: [:destroy]

  # GET /bads
  # GET /bads.json
  def index
    @bads = Bad.where(user_id: current_user.id).order(id: "DESC")
  end

  # GET /bads/1
  # GET /bads/1.json
  def show
  end

  # POST /bads
  # POST /bads.json
  def create
    @bad = Bad.new(bad_params)
    @bad.user_id = current_user.id
    @bad.create_datetime = Time.current

    respond_to do |format|
      if @bad.save
        format.html { redirect_to :back, notice: "Bad was successfully created." }
        format.json { render :show, status: :created, location: @bad }
      else
        format.html { render :new }
        format.json { render json: @bad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bads/1
  # DELETE /bads/1.json
  def destroy
    if @bad.user_id == current_user.id
      @bad.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: "Bad was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, alert: "You don't have permission." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bad
      @bad = Bad.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bad_params
      params.require(:bad).permit(:tweet_id, :user_id, :create_datetime)
    end
end
