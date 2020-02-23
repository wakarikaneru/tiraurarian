namespace :distribute_points do
  desc "distribute_points"
  task distribute_points: :environment do
    User.distribute_points
  end
end
