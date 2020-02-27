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
      @messages = Message.none.or(messages).where("create_datetime > ?", Constants::MESSAGE_RETENTION_PERIOD.ago).order(create_datetime: :desc)

      send_messages = Message.where(sender_id: current_user.id)
      @send_messages = Message.none.or(send_messages).where("create_datetime > ?", Constants::MESSAGE_RETENTION_PERIOD.ago).order(create_datetime: :desc)

      @messages.update(read_flag: true)

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

        if @message.user_id == current_user.id
          @target = @message.sender
        else
          @target = @message.user
        end

        receive_messages = Message.where(user_id: current_user.id, sender_id: @target.id)
        send_messages = Message.where(user_id: @target.id, sender_id: current_user.id)
        messages = Message.none.or(receive_messages).or(send_messages)
        @messages = Message.none.or(messages).where("create_datetime > ?", Constants::MESSAGE_RETENTION_PERIOD.ago).order(create_datetime: :desc)

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
    user = User.find_by(id: params[:user_id])
    if user.present?
      @message = Message.new
      @message.user_id = user.id
    else
      redirect_to messages_path
    end
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)
    @message.sender_id = current_user.id
    @message.sender_name = current_user.name
    @message.read_flag = false
    @message.create_datetime = Time.current

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
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
