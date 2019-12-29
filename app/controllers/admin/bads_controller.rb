class Admin::BadsController < AdministrationController
  before_action :set_bad, only: [:show, :edit, :update, :destroy]

  # GET /bads
  # GET /bads.json
  def index
    @bads = Bad.all.order(id: :desc)
  end

  # GET /bads/1
  # GET /bads/1.json
  def show
  end

  # GET /bads/new
  def new
    @bad = Bad.new
  end

  # GET /bads/1/edit
  def edit
  end

  # POST /bads
  # POST /bads.json
  def create
    @bad = Bad.new(bad_params)

    respond_to do |format|
      if @bad.save
        format.html { redirect_to [:admin, @bad], notice: 'Bad was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @bad] }
      else
        format.html { render :new }
        format.json { render json: @bad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bads/1
  # PATCH/PUT /bads/1.json
  def update
    respond_to do |format|
      if @bad.update(bad_params)
        format.html { redirect_to [:admin, @bad], notice: 'Bad was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @bad] }
      else
        format.html { render :edit }
        format.json { render json: @bad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bads/1
  # DELETE /bads/1.json
  def destroy
    @bad.destroy
    respond_to do |format|
      format.html { redirect_to admin_bads_url, notice: 'Bad was successfully destroyed.' }
      format.json { head :no_content }
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
