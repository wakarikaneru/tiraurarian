class TiramonBattleCompleterJob < ApplicationJob
  queue_as :tiramon_battle_completer

  def perform()
    incomplete_battles = TiramonBattle.where(result: nil).where("datetime < ?", Time.current).order(datetime: :asc)
    incomplete_battles.each do |battle|
      battle.set_result
    end
  end
end
