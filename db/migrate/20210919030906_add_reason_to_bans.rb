class AddReasonToBans < ActiveRecord::Migration[6.1]
  def change
    add_column :bans, :reason, :string
  end
end
