class AddSafeToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :adult, :integer, default: 0
    add_column :tweets, :spoof, :integer, default: 0
    add_column :tweets, :medical, :integer, default: 0
    add_column :tweets, :violence, :integer, default: 0
    add_column :tweets, :racy, :integer, default: 0
  end
end
