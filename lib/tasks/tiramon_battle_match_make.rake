namespace :tiramon_battle_match_make do
  desc "tiramon_battle_match_make"
  task championship: :environment do
    TiramonBattle.match_make(0)
  end
  task heavy: :environment do
    TiramonBattle.match_make(1)
  end
  task junior: :environment do
    TiramonBattle.match_make(2)
  end
  task under_match: :environment do
    TiramonBattle.match_make(3)
  end
end
