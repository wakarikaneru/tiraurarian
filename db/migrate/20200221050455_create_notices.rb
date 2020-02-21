class CreateNotices < ActiveRecord::Migration[5.0]
  def change
    create_table :notices do |t|
      t.integer :user_id
      t.string :title
      t.string :sender
      t.text :content
      t.boolean :read_flag
      t.datetime :create_datetime

      t.timestamps
    end
  end
end
