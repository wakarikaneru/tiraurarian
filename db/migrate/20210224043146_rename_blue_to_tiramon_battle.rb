class RenameBlueToTiramonBattle < ActiveRecord::Migration[5.2]
  def change
    rename_column :tiramon_battles, :blue, :blue_tiramon_id
  end
end
