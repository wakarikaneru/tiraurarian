namespace :access_log do
  desc "access_log"
  task sum: :environment do
    AccessLogSumJob.perform_later
  end
end
