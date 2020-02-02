class AddResCountToTweets < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :res_count, :integer, default: 0
  end
end
