namespace :log_stat do
  desc "log_stat"
  task log_stat: :environment do
    stat = Stat.new
    stat.datetime = Time.current
    stat.load = AccessLog.where("access_datetime > ?", 10.minutes.ago).count
    stat.users = AccessLog.where("access_datetime > ?", 10.minutes.ago).select(:ip_address).distinct.count
    stat.save!
  end
end
