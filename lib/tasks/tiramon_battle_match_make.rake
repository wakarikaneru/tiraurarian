namespace :tiramon_battle_match_make do
  desc "tiramon_battle_match_make"
  task mania: :environment do
    TiramonBattleMatchMakeJob.perform_later(0)
  end
  task championship: :environment do
    TiramonBattleMatchMakeJob.perform_later(1)
  end
  task heavy: :environment do
    TiramonBattleMatchMakeJob.perform_later(2)
  end
  task junior: :environment do
    TiramonBattleMatchMakeJob.perform_later(3)
  end
  task normal_match: :environment do
    TiramonBattleMatchMakeJob.perform_later(4)
  end
  task under_match: :environment do
    TiramonBattleMatchMakeJob.perform_later(5)
  end
  task ranked_match: :environment do
    TiramonBattleMatchMakeJob.perform_later(-1)
  end
end
