class AddContextToTweets < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :context, :integer, default: 0
  end
end
