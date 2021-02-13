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
  rake 'log_stat:log_stat'
end

every 1.days, at: '23:59' do
  rake 'collect_points:collect_points'
end

every 1.hours do
  rake 'distribute_points:distribute_points'
end

every 1.minutes do
  rake 'stock_fluctuation:stock_fluctuation'
end

every 10.minutes do
  rake 'refresh_environment:refresh_environment'
end

every 1.days, at: '00:00' do
  rake 'get_trial:get_trial'
end
