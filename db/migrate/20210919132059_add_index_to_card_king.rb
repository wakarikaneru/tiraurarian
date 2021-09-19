class AddIndexToCardKing < ActiveRecord::Migration[6.1]
  def change
    add_index :card_kings, :rule
    add_index :card_kings, :user_id
    add_index :card_kings, :card_deck_id
    add_index :card_kings, :defense
  end
end
