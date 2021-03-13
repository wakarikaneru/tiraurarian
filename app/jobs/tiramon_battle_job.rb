class TiramonBattleJob < ApplicationJob
  queue_as :tiramon

  def perform()
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
