namespace :tiramon_battle do
  desc "tiramon_battle"
  task complete: :environment do
    TiramonBattleCompleterJob.perform_later
  end
  task daily_task: :environment do
    TiramonBattleCompleterJob.perform_later

    TiramonBattle.prize
    last_mania = TiramonBattle.where(rank: 0).where("datetime < ?", Time.current).order(datetime: :desc).first
    TiramonBet.pay_off(last_mania)

    TiramonTrainer.recovery

    Tiramon.set_miss
    Tiramon.leave
  end
end
