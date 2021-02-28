class AddMatchTimeToTiramonBattle < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramon_battles, :match_time, :integer, default: 0
  end
end
