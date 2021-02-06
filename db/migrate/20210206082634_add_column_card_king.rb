class AddColumnCardKing < ActiveRecord::Migration[5.2]
  def change
    add_column :card_kings, :last_challenger_id, :integer
  end
end
