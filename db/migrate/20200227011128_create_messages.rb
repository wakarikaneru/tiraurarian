class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :sender_id
      t.string :sender
      t.string :title
      t.string :content
      t.boolean :read_flag
      t.datetime :create_datetime

      t.timestamps
    end
  end
end
