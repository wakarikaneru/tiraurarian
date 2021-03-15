class TiramonBattleCompleterJob < ApplicationJob
  queue_as :tiramon_battle_completer

  def perform()
    incomplete_battle_count = TiramonBattle.where(result: nil).where("datetime < ?", Time.current).order(datetime: :asc).count
    incomplete_battle_count.times do
      TiramonBattleJob.perform_later
    end
  end
end
