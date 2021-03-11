namespace :tiramon_battle do
  desc "tiramon_battle"
  task complete: :environment do
    incomplete_battles = TiramonBattle.where(result: nil).where("datetime < ?", Time.current)
    incomplete_battles.find_each do |battle|
      battle.set_result
    end
  end
end
