class AddLoginIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :login_id, :string, null: false, default: ""
    add_index :users, :login_id, unique: true
  end
end
