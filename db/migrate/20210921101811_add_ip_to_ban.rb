class AddIpToBan < ActiveRecord::Migration[6.1]
  def change
    add_column :bans, :ip, :string
  end
end
