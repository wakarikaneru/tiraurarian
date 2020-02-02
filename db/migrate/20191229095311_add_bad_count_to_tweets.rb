class AddBadCountToTweets < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :bad_count, :integer, default: 0
  end
end
