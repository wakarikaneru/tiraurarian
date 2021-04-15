class AddIconToTiramon < ActiveRecord::Migration[6.1]
  def change
    add_column :tiramons, :icon, :integer
  end
end
