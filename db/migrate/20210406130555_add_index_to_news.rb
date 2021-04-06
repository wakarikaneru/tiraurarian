class AddIndexToNews < ActiveRecord::Migration[6.1]
  def change
    add_index :news, :priority
    add_index :news, :expiration
  end
end
