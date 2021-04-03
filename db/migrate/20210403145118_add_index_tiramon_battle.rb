class AddIndexTiramonBattle < ActiveRecord::Migration[6.1]
  def change
    add_index :tiramon_battles, :datetime
    add_index :tiramon_battles, :rank
    add_index :tiramon_battles, :red_tiramon_id
    add_index :tiramon_battles, :blue_tiramon_id
  end
end
