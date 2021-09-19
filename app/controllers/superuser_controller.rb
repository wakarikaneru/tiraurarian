class SuperuserController < ApplicationController

  def delete_tweet
    tweet_id = params[:tweet_id]

    if user_signed_in?
      if Permission.find_by(user_id: current_user.id).present?
        level = Permission.find_by(user_id: current_user.id).level
        if 1 <= level

          tweet = Tweet.find(tweet_id)
          tweet.destroy

          redirect_to root_path, notice: "つぶやき##{tweet_id}を削除しました"
          return
        end
      end
    end
    redirect_to root_path
  end

  def ban_1h
    tweet_id = params[:tweet_id]

    if user_signed_in?
      if Permission.find_by(user_id: current_user.id).present?
        level = Permission.find_by(user_id: current_user.id).level
        if 1 <= level

          tweet = Tweet.find(tweet_id)

          ban = Ban.new
          ban.host = tweet.host
          ban.period = 1.hour.since
          ban.create_user_id = current_user.id

          if ban.save
            redirect_back(fallback_location: root_path, notice: "アク禁しました。" )
          else
            redirect_back(fallback_location: root_path, alert: "アク禁できませんでした。" )
          end

          return
        end
      end
    end
    redirect_to root_path
  end

  def ban_1d
    tweet_id = params[:tweet_id]

    if user_signed_in?
      if Permission.find_by(user_id: current_user.id).present?
        level = Permission.find_by(user_id: current_user.id).level
        if 1 <= level

          tweet = Tweet.find(tweet_id)

          ban = Ban.new
          ban.host = tweet.host
          ban.period = 1.day.since
          ban.create_user_id = current_user.id

          if ban.save
            redirect_back(fallback_location: root_path, notice: "アク禁しました。" )
          else
            redirect_back(fallback_location: root_path, alert: "アク禁できませんでした。" )
          end

          return
        end
      end
    end
    redirect_to root_path
  end

  def ban_1w
    tweet_id = params[:tweet_id]

    if user_signed_in?
      if Permission.find_by(user_id: current_user.id).present?
        level = Permission.find_by(user_id: current_user.id).level
        if 1 <= level

          tweet = Tweet.find(tweet_id)

          ban = Ban.new
          ban.host = tweet.host
          ban.period = 1.week.since
          ban.create_user_id = current_user.id

          if ban.save
            redirect_back(fallback_location: root_path, notice: "アク禁しました。" )
          else
            redirect_back(fallback_location: root_path, alert: "アク禁できませんでした。" )
          end

          return
        end
      end
    end
    redirect_to root_path
  end

  def ban_1m
    tweet_id = params[:tweet_id]

    if user_signed_in?
      if Permission.find_by(user_id: current_user.id).present?
        level = Permission.find_by(user_id: current_user.id).level
        if 1 <= level

          tweet = Tweet.find(tweet_id)

          ban = Ban.new
          ban.host = tweet.host
          ban.period = 1.month.since
          ban.create_user_id = current_user.id

          if ban.save
            redirect_back(fallback_location: root_path, notice: "アク禁しました。" )
          else
            redirect_back(fallback_location: root_path, alert: "アク禁できませんでした。" )
          end

          return
        end
      end
    end
    redirect_to root_path
  end

end
