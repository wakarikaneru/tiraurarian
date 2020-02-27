class CreateCardDecks < ActiveRecord::Migration[5.0]
  def change
    create_table :card_decks do |t|
      t.integer :card_box_id
      t.integer :rule
      t.integer :card_1
      t.integer :card_2
      t.integer :card_3
      t.datetime :create_datetime

      t.timestamps
    end
  end
end
