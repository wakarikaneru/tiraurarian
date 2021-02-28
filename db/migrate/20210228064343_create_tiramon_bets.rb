class CreateTiramonBets < ActiveRecord::Migration[5.2]
  def change
    create_table :tiramon_bets do |t|
      t.integer :tiramon_battle_id
      t.integer :user_id
      t.integer :bet
      t.integer :bet_amount

      t.timestamps
    end
  end
end
