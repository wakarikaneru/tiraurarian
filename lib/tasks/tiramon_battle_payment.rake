namespace :tiramon_battle_payment do
  desc "tiramon_battle_payment"
  task tiramon_battle_payment: :environment do
    TiramonBattle.prize
  end
end
