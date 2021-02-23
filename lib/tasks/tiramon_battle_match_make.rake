namespace :tiramon_battle_match_make do
  desc "tiramon_battle_match_make"
  task tiramon_battle_match_make: :environment do
    TiramonBattle.match_make
  end
end
