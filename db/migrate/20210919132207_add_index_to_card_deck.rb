class AddIndexToCardDeck < ActiveRecord::Migration[6.1]
  def change
    add_index :card_decks, :card_box_id
    add_index :card_decks, :rule
    add_index :card_decks, :card_1_id
    add_index :card_decks, :card_2_id
    add_index :card_decks, :card_3_id
    add_index :card_decks, :create_datetime
  end
end
