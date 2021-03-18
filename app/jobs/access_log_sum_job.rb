class AccessLogSumJob < ApplicationJob
  queue_as :access_log_sum

  def perform(*args)
    datetime = Time.current
    load = AccessLog.where("access_datetime > ?", 10.minutes.ago).count
    users = AccessLog.where("access_datetime > ?", 10.minutes.ago).select(:ip_address).distinct.count
    Stat.create(datetime: datetime, load: load, users: users)
  end
end
