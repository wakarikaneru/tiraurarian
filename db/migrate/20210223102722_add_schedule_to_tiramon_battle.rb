class AddScheduleToTiramonBattle < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramon_battles, :schedule, :datetime
  end
end
