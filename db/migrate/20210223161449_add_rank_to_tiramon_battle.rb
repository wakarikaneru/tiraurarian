class AddRankToTiramonBattle < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramon_battles, :rank, :integer
  end
end
