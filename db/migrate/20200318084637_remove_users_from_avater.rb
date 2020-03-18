class RemoveUsersFromAvater < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :avater_file_name, :string
    remove_column :users, :avater_content_type, :string
    remove_column :users, :avater_file_size, :string
    remove_column :users, :avater_updated_at, :string
  end
end
