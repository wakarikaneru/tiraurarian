class AddViewCountToTweet < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :view_count, :integer, default: 0
  end
end
