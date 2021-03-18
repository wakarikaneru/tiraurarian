namespace :tiramon_battle do
  desc "tiramon_battle"
  task complete: :environment do
    TiramonBattleCompleterJob.perform_later
  end
end
