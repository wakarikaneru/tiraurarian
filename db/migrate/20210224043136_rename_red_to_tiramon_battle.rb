class RenameRedToTiramonBattle < ActiveRecord::Migration[5.2]
  def change
    rename_column :tiramon_battles, :red, :red_tiramon_id
  end
end
