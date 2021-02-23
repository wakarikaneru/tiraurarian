namespace :tiramon_trainer_recovery do
  desc "tiramon_trainer_recovery"
  task tiramon_trainer_recovery: :environment do
    TiramonTrainer.recovery
  end
end
