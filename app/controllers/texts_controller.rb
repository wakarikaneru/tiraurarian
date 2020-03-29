class TextsController < ApplicationController
  before_action :set_text, only: [:show]

  # GET /texts/1
  # GET /texts/1.json
  def show
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_text
      @text = Text.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def text_params
      params.require(:text).permit(:tweet_id, :user_id, :content, :create_datetime)
    end
end
