class AddIndexToTiramon2 < ActiveRecord::Migration[6.1]
  def change
    add_index :tiramons, :act
    add_index :tiramons, :get_limit
    add_index :tiramons, :right
    add_index :tiramons, :rank
    add_index :tiramons, :auto_rank
  end
end
