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

env :PATH, ENV['PATH']

set :output, 'log/crontab.log'
job_type :rbenv_rake, %Q!PATH="#{DIR_RBENV_BIN}:$PATH"; eval "$(rbenv init -)"; cd :path && :bundle_command rake :task --silent :output!


rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env

every 1.days, at: '23:59' do
  rbenv_rake 'collect_points:collect_points'
end

every 1.hours, at: 00 do
  rbenv_rake 'distribute_points:distribute_points'
end
