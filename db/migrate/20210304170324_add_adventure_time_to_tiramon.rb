class AddAdventureTimeToTiramon < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramons, :adventure_time, :datetime
  end
end
