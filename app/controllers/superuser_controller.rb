class SuperuserController < ApplicationController

  def nsfw_tweet
    tweet_id = params[:tweet_id]

    if user_signed_in?
      if Permission.find_by(user_id: current_user.id).present?
        level = Permission.find_by(user_id: current_user.id).level
        if 1 <= level

          tweet = Tweet.find(tweet_id)
          tweet.nsfw = true

          if tweet.save
            redirect_back(fallback_location: root_path, notice: "つぶやき##{tweet_id}をNSFWにしました" )
          else
            redirect_back(fallback_location: root_path, alert: "つぶやき##{tweet_id}をNSFWにできませんでした" )
          end
          return
        end
      end
    end
    redirect_to root_path
  end

  def delete_tweet
    tweet_id = params[:tweet_id]

    if user_signed_in?
      if Permission.find_by(user_id: current_user.id).present?
        level = Permission.find_by(user_id: current_user.id).level
        if 1 <= level

          tweet = Tweet.find(tweet_id)

          dl = DeleteLog.new
          dl.tweet_id = tweet.id
          dl.tweet_content = tweet.content
          dl.tweet_user_id = tweet.user_id
          dl.tweet_ip = tweet.ip
          dl.tweet_host = tweet.host
          dl.delete_user_id = current_user.id

          if dl.save
            if tweet.destroy
              redirect_to root_path, notice: "つぶやき##{tweet_id}を削除しました"
            else
              redirect_back(fallback_location: root_path, alert: "つぶやき##{tweet_id}を削除できませんでした" )
            end
          else
            redirect_back(fallback_location: root_path, alert: "つぶやき##{tweet_id}を削除できませんでした" )
          end

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
          ban.reason = tweet.content
          ban.ip = tweet.ip
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
        if 10 <= level

          tweet = Tweet.find(tweet_id)

          ban = Ban.new
          ban.reason = tweet.content
          ban.ip = tweet.ip
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
        if 10 <= level

          tweet = Tweet.find(tweet_id)

          ban = Ban.new
          ban.reason = tweet.content
          ban.ip = tweet.ip
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
        if 10 <= level

          tweet = Tweet.find(tweet_id)

          ban = Ban.new
          ban.reason = tweet.content
          ban.ip = tweet.ip
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
