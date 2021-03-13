namespace :tiramon_battle do
  desc "tiramon_battle"
  task complete: :environment do
    while true do
      battle = TiramonBattle.where(result: nil).where("datetime < ?", Time.current).order(datetime: :asc).first
      if battle.present?
        battle.set_result
      else
        break
      end
    end
  end
end
