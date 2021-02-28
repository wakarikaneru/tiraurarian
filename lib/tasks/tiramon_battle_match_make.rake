namespace :tiramon_battle_match_make do
  desc "tiramon_battle_match_make"
  task mania: :environment do
    TiramonBattle.match_make(0)
  end
  task championship: :environment do
    TiramonBattle.match_make(1)
  end
  task heavy: :environment do
    TiramonBattle.match_make(2)
  end
  task junior: :environment do
    TiramonBattle.match_make(3)
  end
  task normal_match: :environment do
    roster = Tiramon.where(rank: 4).where.not(tiramon_trainer: nil).count
    match_num = [roster.to_f / 16.0, 1.0].max.to_i
    match_num.times do
      TiramonBattle.match_make(4)
    end
  end
  task under_match: :environment do
    roster = Tiramon.where(rank: 5).where.not(tiramon_trainer: nil).count
    match_num = [roster.to_f / 16.0, 1.0].max.to_i
    match_num.times do
      TiramonBattle.match_make(5)
    end
  end
end
