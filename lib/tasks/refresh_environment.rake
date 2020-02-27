namespace :refresh_environment do
  desc "refresh_environment"
  task refresh_environment: :environment do
    Card.refresh_environment
  end
end
