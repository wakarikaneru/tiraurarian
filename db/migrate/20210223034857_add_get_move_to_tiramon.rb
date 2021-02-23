class AddGetMoveToTiramon < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramons, :get_move, :text
  end
end
