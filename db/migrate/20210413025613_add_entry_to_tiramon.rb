class AddEntryToTiramon < ActiveRecord::Migration[6.1]
  def change
    add_column :tiramons, :entry, :boolean, default: false, null: false
  end
end
