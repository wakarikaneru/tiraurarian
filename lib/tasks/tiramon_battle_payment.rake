namespace :tiramon_battle_payment do
  desc "tiramon_battle_payment"
  task tiramon_battle_payment: :environment do
    TiramonBattle.prize

    last_mania = TiramonBattle.where(rank: 0).where("datetime < ?", Time.current).order(datetime: :desc).first
    TiramonBet.pay_off(last_mania)
  end
end
