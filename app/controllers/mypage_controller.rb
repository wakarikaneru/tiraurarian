class MypageController < ApplicationController

  def index

    @tweets = Tweet.none
    @tags = Tag.none

    if user_signed_in? then
      my_mutes = Mute.where(user_id: current_user.id).select(:target_id)
      my_tweets_res = Tweet.joins(:parent).where(parents_tweets: {user_id: current_user.id}).where.not(user_id: current_user.id).where.not(user_id: my_mutes).order(id: :desc)

      @tags = Tag.where(user_id: current_user.id).group(:tag_string).order("max(create_datetime) desc").limit(15)

      if my_tweets_res.present?
        current_user.update(last_check_res: my_tweets_res.first.id)
      end
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path, alert: 'ログインしてください。' }
        format.json { head :no_content }
      end
    end

  end

end
