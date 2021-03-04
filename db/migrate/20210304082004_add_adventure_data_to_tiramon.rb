class AddAdventureDataToTiramon < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramons, :adventure_data, :text
  end
end
