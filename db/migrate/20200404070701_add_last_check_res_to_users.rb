class AddLastCheckResToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_check_res, :integer, default: 0
  end
end
