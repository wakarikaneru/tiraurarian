class AddMoveToTiramon < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramons, :move, :text
  end
end
