class AddCreateUserToBans < ActiveRecord::Migration[6.1]
  def change
    add_column :bans, :create_user_id, :integer
  end
end
