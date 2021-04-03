class AddIndexToThumb < ActiveRecord::Migration[6.1]
  def change
    add_index :thumbs, :key
  end
end
