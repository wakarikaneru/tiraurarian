class AddIndexToControl < ActiveRecord::Migration[6.1]
  def change
    add_index :controls, :key
  end
end
