class MypageController < ApplicationController

  def index

    @tweets = Tweet.none
    @tags = Tag.none

    if user_signed_in? then
      my_mutes = Mute.where(user_id: current_user.id).select(:target_id)

      my_tweets = Tweet.where(user_id: current_user.id)
      my_tweets_res = Tweet.where(parent_id: my_tweets).where.not(user_id: current_user.id)

      @tags = Tag.where(user_id: current_user.id).group(:tag_string).order("max(create_datetime) desc").limit(15)

      User.find(current_user.id).update(last_check_res: my_tweets_res.maximum(:id))
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path, alert: 'ログインしてください。' }
        format.json { head :no_content }
      end
    end

  end

end
