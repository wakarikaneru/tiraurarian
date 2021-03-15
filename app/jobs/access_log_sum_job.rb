class AccessLogSumJob < ApplicationJob
  queue_as :access_log_sum

  def perform(*args)
    stat = Stat.new
    stat.datetime = Time.current
    stat.load = AccessLog.where("access_datetime > ?", 10.minutes.ago).count
    stat.users = AccessLog.where("access_datetime > ?", 10.minutes.ago).select(:ip_address).distinct.count
    stat.save!
  end
end
