class AddIndexToStat < ActiveRecord::Migration[6.1]
  def change
    add_index :stats, :datetime
    add_index :stats, :load
    add_index :stats, :users
  end
end
