class AddRightToTiramon < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramons, :right, :integer
  end
end
