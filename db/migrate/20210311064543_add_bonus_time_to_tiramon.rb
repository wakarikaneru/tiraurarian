class AddBonusTimeToTiramon < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramons, :bonus_time, :datetime
  end
end
