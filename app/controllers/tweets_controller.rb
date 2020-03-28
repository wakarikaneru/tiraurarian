class TweetsController < ApplicationController
  require 'digest/md5'
  before_action :authenticate_user!, only: [:destroy]
  before_action :set_tweet, only: [:show, :destroy]

  # GET /tweets
  # GET /tweets.json
  def index
    case params[:mode]
      when "mypage", "follow", "bookmark" then
        respond_to do |format|
          format.html { redirect_to new_user_session_path, alert: 'ログインしてください。' }
          format.json { head :no_content }
        end
    end
    #@hot_tags = Tag.select("tags.*, count(id)").where(tweet_id: tags).group(:tag_string).order("count(id) desc").order("max(id) desc").limit(15)
    @hot_tags = Tag.none

    if user_signed_in? then
      @recent_tags = Tag.where(user_id: current_user.id).group(:tag_string).order("max(id) desc").limit(15)
    end

    @new_tweet = Tweet.new
    @new_tweet.parent_id = 0
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

    @new_tweet = Tweet.new
    @new_tweet.parent_id = @tweet.id

    @good = Good.new
    @good.tweet_id = @tweet.id
    if user_signed_in? then
      @gooded = Good.find_by(user_id: current_user.id, tweet_id: @tweet.id)
    else
      @gooded = Good.none
    end

    @bad = Bad.new
    @bad.tweet_id = @tweet.id
    if user_signed_in? then
      @baded = Bad.find_by(user_id: current_user.id, tweet_id: @tweet.id)
    else
      @baded = Bad.none
    end

    @bookmark = Bookmark.new
    @bookmark.tweet_id = @tweet.id
    if user_signed_in? then
      @bookmarked = Bookmark.find_by(user_id: current_user.id, tweet_id: @tweet.id)
    else
      @bookmarked = Bookmark.none
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
    current_user_id = 0
    if user_signed_in?
      current_user_id = current_user.id
    else
      current_user_id = 2

      key = Date.today.to_s + ":" + request.remote_ip
      thumb = Thumb.find_by(key: key)
      if thumb.present?
        @tweet.avatar = thumb.thumb
      else
        hash = Digest::MD5.hexdigest(key)
        @tweet.avatar_from_url("https://www.gravatar.com/avatar/#{hash}?rating=g&default=retro")
      end
    end

    @tweet.user_id = current_user_id
    @tweet.create_datetime = Time.current

    if Tweet.where(user_id: current_user_id).where("create_datetime > ?", 10.minutes.ago).where(content: @tweet.content).size <= 0
      respond_to do |format|
        if @tweet.save
          format.html { redirect_back(fallback_location: root_path, notice: "つぶやきました。" )}
          format.json { render :show, status: :created, location: @tweet }
        else
          format.html { render :new }
          format.json { render json: @tweet.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "短時間での同一内容の投稿は禁止です。" )}
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
        format.html { redirect_to root_path, notice: "つぶやきを削除しました。" }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "権限がありません。" )}
        format.json { head :no_content }
      end
    end
  end

  def load
    if user_signed_in? then
      my_mutes = Mute.where(user_id: current_user.id).select(:target_id)
    else
      my_mutes = Mute.none
    end

    case params[:mode]
      when "new" then
        tweets = Tweet.all.where.not(user_id: my_mutes)
        @tweets = Tweet.none.or(tweets).order(id: :desc).includes(:user, :parent).page(params[:page]).per(60)

        tags = Tweet.none.or(tweets).where("create_datetime > ?", 1.day.ago)
      when "root" then
        root_tweets = Tweet.where(parent_id: 0)

        tweets = Tweet.none.or(root_tweets).where.not(user_id: my_mutes)
        @tweets = Tweet.none.or(tweets).order(id: :desc).includes(:user, :parent).page(params[:page]).per(60)

        tags = Tweet.none.or(tweets).where("create_datetime > ?", 1.day.ago)
      when "leaf" then
        high_context_tweets = Tweet.where("create_datetime > ?", 1.day.ago).order(context: :desc).order(id: :desc)

        tweets = Tweet.none.or(high_context_tweets).where.not(user_id: my_mutes)
        @tweets = Tweet.none.or(tweets).includes(:user, :parent).page(params[:page]).per(60)

        tags = Tweet.none.or(tweets).where("create_datetime > ?", 1.day.ago)
      when "tweet" then
        if params[:id].blank?
          tweets = Tweet.all.where.not(user_id: my_mutes)
          @tweets = Tweet.none.or(tweets).order(id: :asc).includes(:user, :parent).page(params[:page]).per(60)
          tags = Tweet.where("create_datetime > ?", 1.day.ago)
        else
          res_tweets = Tweet.where(parent_id: params[:id])
          tweets = Tweet.none.or(res_tweets).where.not(user_id: my_mutes)
          @tweets = Tweet.none.or(tweets).order(id: :asc).includes(:user, :parent).page(params[:page]).per(60)
        end
        tags = Tweet.none.or(tweets).where("create_datetime > ?", 1.day.ago)
      when "user" then
        if params[:id].blank?
          tweets = Tweet.all.where.not(user_id: my_mutes)
          @tweets = Tweet.none.or(tweets).order(id: :desc).includes(:user, :parent).page(params[:page]).per(60)
          tags = Tweet.where("create_datetime > ?", 1.day.ago)
        else
          user_tweets = Tweet.where(user_id: params[:id])
          tweets = Tweet.none.or(user_tweets).where.not(user_id: my_mutes)
          @tweets = Tweet.none.or(tweets).order(id: :desc).includes(:user, :parent).page(params[:page]).per(60)
        end

        tags = Tweet.none.or(tweets).where("create_datetime > ?", 1.day.ago)
      when "mypage" then
        if user_signed_in? then
          my_tweets = Tweet.where(user_id: current_user.id)
          my_tweets_res = Tweet.where(parent_id: my_tweets)
          my_follows = Tweet.where(user_id: Follow.where(user_id: current_user.id).select(:target_id))
          my_bookmarks = Tweet.where(id: Bookmark.where(user_id: current_user.id).select(:tweet_id))

          tweets = Tweet.none.or(my_tweets).or(my_tweets_res).or(my_follows).or(my_bookmarks).where.not(user_id: my_mutes)
          @tweets = Tweet.none.or(tweets).order(id: :desc).includes(:user, :parent).page(params[:page]).per(60)

          tags = Tweet.none.or(tweets).where("create_datetime > ?", 1.day.ago)
        else
          tweets = Tweet.none
          @tweets = Tweet.none.or(tweets).includes(:user, :parent).page(params[:page]).per(60)
        end
      when "follow" then
        if user_signed_in? then
          tweets = Tweet.where(user_id: Follow.where(user_id: current_user.id).select(:target_id)).where.not(user_id: my_mutes)
          @tweets = Tweet.none.or(tweets).order(id: :desc).includes(:user, :parent).page(params[:page]).per(60)

          tags = Tweet.none.or(tweets).where("create_datetime > ?", 1.day.ago)
        else
          tweets = Tweet.none
          @tweets = Tweet.none.or(tweets).includes(:user, :parent).page(params[:page]).per(60)
        end
      when "good" then
        hot  = Good.where("goods.create_datetime > ?", 1.day.ago).group(:tweet_id).order("count(goods.id) desc")
        hot_tweets = Tweet.joins(:goods).merge(hot)
        tweets = Tweet.none.or(hot_tweets).where.not(user_id: my_mutes)
        @tweets = Tweet.none.or(tweets).includes(:user, :parent).page(params[:page]).per(60)

        tags = Tweet.none.or(tweets)
      when "bookmark" then
        if user_signed_in? then
          bookmarked = Bookmark.where(user_id: current_user.id).order(create_datetime: :desc)
          bookmarked_tweets  = Tweet.joins(:bookmarks).merge(bookmarked)
          tweets = Tweet.none.or(bookmarked_tweets).where.not(user_id: my_mutes)
          @tweets = Tweet.none.or(tweets).includes(:user, :parent).page(params[:page]).per(60)

          tags = Tweet.none.or(tweets)
        else
          tweets = Tweet.none
          @tweets = Tweet.none.or(tweets).includes(:user, :parent).page(params[:page]).per(60)
        end
      when "tag" then
        if params[:tag].blank?
          tweets = Tweet.all.where.not(user_id: my_mutes)
          @tweets = Tweet.none.or(tweets).order(id: :desc).includes(:user, :parent).page(params[:page]).per(60)

          tags = Tweet.where("create_datetime > ?", 1.day.ago)
        else
          tagged = Tag.where(tag_string: params[:tag]).order(create_datetime: :desc)
          tagged_tweets  = Tweet.joins(:tags).merge(tagged)
          tweets = Tweet.none.or(tagged_tweets).where.not(user_id: my_mutes)
          @tweets = Tweet.none.or(tweets).order(id: :desc).includes(:user, :parent).page(params[:page]).per(60)

          tags = Tweet.where("create_datetime > ?", 1.day.ago)
        end
      else
        tweets = Tweet.all.where.not(user_id: my_mutes)
        @tweets = Tweet.none.or(tweets).order(id: :desc).includes(:user, :parent).page(params[:page]).per(60)

        tags = Tweet.none.or(tweets).where("create_datetime > ?", 1.day.ago)
    end

    @show_list = "true" == params[:show_list]
    @show_parent = "true" == params[:show_parent]
    @infinite_scroll = "true" == params[:infinite_scroll]

    render partial: "layouts/tweets_load"
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
