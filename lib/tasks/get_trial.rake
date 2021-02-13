namespace :get_trial do
  desc "get_trial"
  task get_trial: :environment do
    CardBox.get_trial
  end
end
