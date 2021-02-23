class AddActToTiramon < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramons, :act, :datetime
  end
end
