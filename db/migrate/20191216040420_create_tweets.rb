class CreateTweets < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets do |t|
      t.integer :user_id
      t.integer :parent_id
      t.string :content
      t.datetime :create_date

      t.timestamps
    end
  end
end
