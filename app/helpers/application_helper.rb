module ApplicationHelper
  def notification_counts
    if user_signed_in? then
      notice_records = Notice.where(user_id: current_user.id, read_flag: false).where("create_datetime > ?", Constants::NOTICE_RETENTION_PERIOD.ago)
      message_records = Message.where(user_id: current_user.id, read_flag: false).where("create_datetime > ?", Constants::MESSAGE_RETENTION_PERIOD.ago)

      my_tweets = Tweet.where(user_id: current_user.id)
      my_tweets_res = Tweet.where(id: (current_user.last_check_res + 1)..Float::INFINITY).where(parent_id: my_tweets).where.not(user_id: current_user.id)
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
