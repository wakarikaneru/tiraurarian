class AddHostToTweets < ActiveRecord::Migration[6.1]
  def change
    add_column :tweets, :host, :string
    add_column :tweets, :ip, :string
  end
end
