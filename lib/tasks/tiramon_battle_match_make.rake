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
    TiramonBattle.match_make(4)
  end
  task under_match: :environment do
    TiramonBattle.match_make(5)
  end
end
