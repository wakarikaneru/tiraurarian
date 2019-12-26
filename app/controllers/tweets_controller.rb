class TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :set_tweet, only: [:show, :destroy]

  # GET /tweets
  # GET /tweets.json
  def index

    case params[:mode]
      when "root" then
        @tweets = Tweet.where(parent_id: 0).limit(100).order(id: :desc)
      when "mypage" then
        if user_signed_in? then
          my_tweets = Tweet.where(user_id: current_user.id)
          @tweets = Tweet.where(parent_id: my_tweets).or(Tweet.where(user_id: current_user.id)).limit(100).order(id: :desc)
        else
          redirect_to new_user_session_path
        end
      when "new" then
        @tweets = Tweet.limit(100).order(id: :desc)
      when "follow" then
        if user_signed_in? then
          my_follows = Follow.where(user_id: current_user.id).select(:target_id)
          @tweets = Tweet.where(user_id: my_follows).order(id: :desc).limit(100)
        else
          redirect_to new_user_session_path
        end
      when "good" then
        @tweets = Tweet.select("tweets.*, max(goods.create_datetime)").joins(:goods).group(:id).order("max(goods.create_datetime) desc").limit(100)
      when "bookmark" then
        if user_signed_in? then
          @tweets = Tweet.joins(:bookmarks).where(bookmarks: { user_id: current_user.id }).merge(Bookmark.order(create_datetime: :desc)).limit(100)
        else
          redirect_to new_user_session_path
        end
      when "tag" then
        if params[:tag].blank?
          @tweets = Tweet.order(id: :desc).limit(100)
        else
          tag = params[:tag]
          @tweets = Tweet.where("content like ?","% ##{tag}%").order(id: :desc).limit(100)
        end
      else
        @tweets = Tweet.order(id: :desc).limit(100)
    end

    @new_tweet = Tweet.new
    @new_tweet.parent_id = 0

    @tags = Tag.select("tags.*, count(id)").where("create_datetime > ?", 1.day.ago).group(:tag_string).order("count(id) desc").limit(30)

  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
    @root_tweets = []
    t = Tweet.find_by(id: @tweet.parent_id)
    while t.present? && t.parent_id.present? && t.id != 0 do
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

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    if @tweet.user_id == current_user.id
      @tweet.destroy
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Tweet was successfully destroyed." }
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
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tweet_params
      params.require(:tweet).permit(:id, :user_id, :parent_id, :content, :create_datetime, :image)
    end
end
