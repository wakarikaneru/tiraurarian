namespace :collect_points do
  desc "collect_points"
  task collect_points: :environment do
    User.collect_points
  end
end
