class AddIndexToTiramonBattleResult < ActiveRecord::Migration[6.1]
  def change
    add_index :tiramon_battles, :result
  end
end
