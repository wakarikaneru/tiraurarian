class TiramonBattleJob < ApplicationJob
  queue_as :tiramon

  def perform(battle)
    battle.set_result
  end
end
