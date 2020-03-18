class SearchController < ApplicationController

  def index

    search_str = params[:search]

    if user_signed_in? then
      my_mutes = Mute.where(user_id: current_user.id).select(:target_id)
    else
      my_mutes = Mute.none
    end

    if search_str.blank?
      @users = User.none
      @tweets_tag = Tweet.none
      @tweets_tweet = Tweet.none
    else
      query_array = search_str.split

      my_mutes_array = my_mutes.pluck(:target_id)

      @users = User.ransack(name_or_description_cont_all: query_array, id_does_not_match_all: my_mutes_array).result.order(last_tweet: :desc).limit(100)

      tagged = Tag.ransack(tag_string_matches_any: query_array).result
      tagged_tweets  = Tweet.joins(:tags).merge(tagged)
      tweets = Tweet.none.or(tagged_tweets).where.not(user_id: my_mutes)
      @tweets_tag = Tweet.none.or(tweets).limit(100).order(id: :desc)

      @tweets_tweet = Tweet.ransack(content_cont_all: query_array, id_does_not_match_all: my_mutes_array).result.order(id: :desc).limit(100).includes(:user, :parent)
    end

  end

end
