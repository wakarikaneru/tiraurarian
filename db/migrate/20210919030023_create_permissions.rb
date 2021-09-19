class CreatePermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :permissions do |t|
      t.integer :user_id
      t.integer :level

      t.timestamps
    end
  end
end
