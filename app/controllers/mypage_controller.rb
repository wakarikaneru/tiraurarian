class MypageController < ApplicationController

  def index

    @tweets = Tweet.none
    @tags = Tag.none

    if user_signed_in? then
      my_mutes = Mute.where(user_id: current_user.id).select(:target_id)

      my_tweets = Tweet.where(user_id: current_user.id)
      my_tweets_res = Tweet.where(parent_id: my_tweets)
      my_follows = Tweet.where(user_id: Follow.where(user_id: current_user.id).select(:target_id))
      my_bookmarks = Tweet.where(id: Bookmark.where(user_id: current_user.id).select(:tweet_id))

      tweets = Tweet.none.or(my_tweets).or(my_tweets_res).or(my_follows).or(my_bookmarks).where.not(user_id: my_mutes)
      @tweets = Tweet.none.or(tweets).limit(100).order(id: :desc)

      @tags = Tag.where(user_id: current_user.id).group(:tag_string).order("max(create_datetime) desc").limit(15)
    else
      redirect_to new_user_session_path
    end

  end

end
