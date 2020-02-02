class CreateAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :admins do |t|
      t.integer :user_id
      t.integer :permission
      t.datetime :create_datetime

      t.timestamps
    end
  end
end
