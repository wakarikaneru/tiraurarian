module ApplicationHelper
  def notification_counts
    if user_signed_in? then
      notice_records = Notice.where(user_id: current_user.id, read_flag: false).where("create_datetime > ?", Constants::NOTICE_RETENTION_PERIOD.ago)
      message_records = Message.where(user_id: current_user.id, read_flag: false).where("create_datetime > ?", Constants::MESSAGE_RETENTION_PERIOD.ago)

      my_mutes = Mute.where(user_id: current_user.id).select(:target_id)
      my_tweets_res = Tweet.joins(:parent).where("? < tweets.id", current_user.last_check_res).where(parents_tweets: {user_id: current_user.id}).where.not(user_id: current_user.id).where.not(user_id: my_mutes).order(id: :desc)
      res_count = my_tweets_res.count
    else
      notice_records = Notice.none
      message_records = Message.none
      res_count = 0
    end

    notice_count = notice_records.count
    message_count = message_records.count
    total_count = notice_count + message_count

    notification = {datetime: Time.current.to_s, res: res_count, notice: notice_count, message: message_count, total: total_count}
    return notification
  end

end
