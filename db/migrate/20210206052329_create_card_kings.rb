class CreateCardKings < ActiveRecord::Migration[5.2]
  def change
    create_table :card_kings do |t|
      t.integer :rule
      t.integer :user_id
      t.integer :card_deck_id
      t.integer :defense

      t.timestamps
    end
  end
end
