class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :destroy]

  # GET /messages
  # GET /messages.json
  def index

    @messages = Message.none

    if user_signed_in? then
      my_mutes = Mute.where(user_id: current_user.id).select(:target_id)

      receive_messages = Message.where(user_id: current_user.id)
      messages = Message.none.or(receive_messages).where.not(sender_id: my_mutes)
      @messages = Message.none.or(messages).where("create_datetime > ?", 7.days.ago).order(create_datetime: :desc)

    else
      redirect_to new_user_session_path
    end

  end

  # GET /messages/1
  # GET /messages/1.json
  def show

    @messages = Message.none

    if user_signed_in? then
      if @message.user_id == current_user.id || @message.sender_id == current_user.id

        receive_messages = Message.where(user_id: current_user.id, sender_id: @message.sender_id)
        send_messages = Message.where(user_id: @message.sender_id, sender_id: current_user.id)
        messages = Message.none.or(receive_messages).or(send_messages)
        @messages = Message.none.or(messages).where("create_datetime > ?", 7.days.ago).order(create_datetime: :desc)

        @new_message = Message.new
        @new_message.user_id = @message.sender_id
      else
        redirect_to messages_path
      end
    else
      redirect_to new_user_session_path
    end

  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)
    @message.sender_id = current_user.id
    @message.sender_name = current_user.name
    @message.create_datetime = Time.current

    respond_to do |format|
      if @message.save
        format.html { redirect_to :back, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    if @message.user_id == current_user.id || @message.sender_id == current_user.id
      @message.destroy
      respond_to do |format|
        format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
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
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:user_id, :sender_id, :sender_name, :title, :content, :read_flag, :create_datetime)
    end
end
