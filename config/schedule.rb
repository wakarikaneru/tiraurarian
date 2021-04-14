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

every 1.minutes do
  rake 'access_log:sum'
end

every 1.days, at: '23:59' do
  rake 'collect_points:collect_points'
end

every 1.hours do
  rake 'distribute_points:distribute_points'
end

every 1.minutes do
  rake 'stock:fluctuation'
end

every 10.minutes do
  rake 'refresh_environment:refresh_environment'
end

every 1.days, at: '00:05' do
  rake 'get_trial:get_trial'
end

every '0 19 * * 6' do
  rake 'tiramon_battle_match_make:mania'
end
every 1.days, at: '12:00' do
  rake 'tiramon_battle_match_make:championship'
end
every '0 5,11,17,23 * * *' do
  rake 'tiramon_battle_match_make:superheavy'
end
every '0 3,7,11,15,19,23 * * *' do
  rake 'tiramon_battle_match_make:heavy'
end
every '0 2,5,8,11,14,17,20,23 * * *' do
  rake 'tiramon_battle_match_make:junior'
end
every '0 1,3,5,7,9,11,13,15,17,19,21,23 * * *' do
  rake 'tiramon_battle_match_make:normal_match'
end
every 20.minutes do
  rake 'tiramon_battle_match_make:under_match'
end

every 10.minutes do
  rake 'tiramon_battle_match_make:ranked_match'
end

every 1.days, at: '22:30' do
  rake 'tiramon_battle:rank'
end

every 1.days, at: '00:05' do
  rake 'tiramon_battle:daily_task'
end


every 10.minutes do
  rake 'news:stock_news'
end

every 1.minutes do
  rake 'bot:talk'
end
