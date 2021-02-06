class RenameCardColumnToCardDecks < ActiveRecord::Migration[5.2]
  def change
    rename_column :card_decks, :card_1, :card_1_id
    rename_column :card_decks, :card_2, :card_2_id
    rename_column :card_decks, :card_3, :card_3_id
  end
end
