class TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]

  # GET /tweets
  # GET /tweets.json
  def index

    case params[:mode]
      when "root" then
        @tweets = Tweet.where(parent_id: 0).limit(100).order(id: :desc)
      when "mypage" then
        if user_signed_in? then
          myTweets = Tweet.where(user_id: current_user.id)
          @tweets = Tweet.where(parent_id: myTweets).or(Tweet.where(user_id: current_user.id)).limit(100).order(id: :desc)
        else
          redirect_to new_user_session_path
        end
      when "new" then
        @tweets = Tweet.limit(100).order(id: :desc)
      when "follow" then
        if user_signed_in? then
          follows = Follow.where(user_id: current_user.id).select(:target_id)
          @tweets = Tweet.where(user_id: follows).limit(100).order(id: :desc)
        else
          redirect_to new_user_session_path
        end
      when "good" then
        @tweets = Tweet.joins(:goods).group(:id).limit(100).order("max(goods.create_datetime) DESC")
      when "bookmark" then
        if user_signed_in? then
          bookmarkTweets = Bookmark.where(user_id: current_user.id).select(:tweet_id, :create_datetime)
          @tweets = Tweet.where(id: bookmarkTweets).limit(100).order(id: :desc)
        else
          redirect_to new_user_session_path
        end
      when "hash" then
        if params[:hash].blank?
          @tweets = Tweet.limit(100).order(id: :desc)
        else
          hash = params[:hash]
          @tweets = Tweet.where("content like ?","% ##{hash}%").limit(100).order(id: :desc)
        end
      else
        @tweets = Tweet.limit(100).order(id: :desc)
    end

    @new_tweet = Tweet.new
    @new_tweet.parent_id = 0
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
    @root_tweets = []
    t = Tweet.find_by(id: @tweet.parent_id)
    while !t.nil? && !t.parent_id.nil? && t.id != 0 do
      @root_tweets.push(t)
      t = Tweet.find_by(id: t.parent_id)
    end
    @root_tweets.reverse!

    @res_tweets = Tweet.where(parent_id: @tweet.id).order(id: "ASC")
    @new_tweet = Tweet.new
    @new_tweet.parent_id = @tweet.id

    @good = Good.new
    @good.tweet_id = @tweet.id

    if user_signed_in? then
      @gooded = Good.find_by(user_id: current_user.id, tweet_id: @tweet.id)
    else
      @gooded = nil
    end

    @bookmark = Bookmark.new
    @bookmark.tweet_id = @tweet.id

    if user_signed_in? then
      @bookmarked = Bookmark.find_by(user_id: current_user.id, tweet_id: @tweet.id)
    else
      @bookmarked = nil
    end
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = Tweet.new(tweet_params)

    @tweet.user_id = current_user.id
    @tweet.create_datetime = Time.current

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to :back, notice: 'Tweet was successfully created.' }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { render :new }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    if @tweet.user_id == current_user.id
      respond_to do |format|
        if @tweet.update(tweet_params)
          format.html { redirect_to  @tweet, notice: "Tweet was successfully updated." }
          format.json { render :show, status: :ok, location: @tweet }
        else
          format.html { render :edit }
          format.json { render json: @tweet.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to @tweet, alert: "You don't have permission."
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    if @tweet.user_id == current_user.id
      @tweet.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: "Tweet was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, alert: "You don't have permission." }
        format.json { head :no_content }
      end
    end
  end

  def to_link(text)
    URI.extract(text, ["http", "https"]).uniq.each do |url|
      text.gsub!(url, "#{url}")
    end
  end

  helper_method :to_link

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tweet_params
      params.require(:tweet).permit(:id, :user_id, :parent_id, :content, :create_datetime, :image)
    end
end
