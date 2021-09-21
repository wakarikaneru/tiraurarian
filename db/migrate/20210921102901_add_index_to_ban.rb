class AddIndexToBan < ActiveRecord::Migration[6.1]
  def change
    add_index :bans, :ip
    add_index :bans, :host
    add_index :bans, :create_user_id
    add_index :bans, :period
  end
end
