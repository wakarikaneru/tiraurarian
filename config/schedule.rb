# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

require File.expand_path(File.dirname(__FILE__) + "/environment")

env :PATH, ENV['PATH']
env :GEM_PATH, ENV['GEM_PATH']

set :output, 'log/crontab.log'

rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
set :runner_command, "rails runner"

every 1.minutes do
  runner 'AccessLogSumJob.perform_later'
end

every 1.days, at: '23:59' do
  rake 'collect_points:collect_points'
end

every 1.hours do
  rake 'distribute_points:distribute_points'
end

every 1.minutes do
  runner "StockJob.perform_later"
end

every 10.minutes do
  rake 'refresh_environment:refresh_environment'
end

every 1.days, at: '00:05' do
  rake 'get_trial:get_trial'
end

every '0 19 * * 6' do
  runner "TiramonBattleMatchMakeJob.perform_later(0)"
end
every 1.days, at: '12:00' do
  runner "TiramonBattleMatchMakeJob.perform_later(1)"
end
every '0 3,7,11,15,19,23 * * *' do
  runner "TiramonBattleMatchMakeJob.perform_later(2)"
end
every '0 2,5,8,11,14,17,20,23 * * *' do
  runner "TiramonBattleMatchMakeJob.perform_later(3)"
end
every 20.minutes do
  runner "TiramonBattleMatchMakeJob.perform_later(4)"
end
every 10.minutes do
  runner "TiramonBattleMatchMakeJob.perform_later(5)"
end

every 10.minutes do
  runner "TiramonBattleMatchMakeJob.perform_later(-1)"
end

every 1.minutes do
  runner "TiramonBattleCompleterJob.perform_later"
end


every 1.days, at: '00:05' do
  rake 'tiramon_battle_payment:tiramon_battle_payment'
end

every 1.days, at: '00:05' do
  rake 'tiramon_trainer_recovery:tiramon_trainer_recovery'
end


every 10.minutes do
  rake 'news:stock_news'
end
