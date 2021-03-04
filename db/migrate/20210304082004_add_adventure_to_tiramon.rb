class AddAdventureToTiramon < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramons, :adventure, :text
  end
end
