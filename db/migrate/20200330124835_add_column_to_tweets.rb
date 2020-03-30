class AddColumnToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :humanity, :float, default: 0
    add_column :tweets, :sensitivity, :float, default: 0
  end
end
