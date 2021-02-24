class CreateTiramonBattlePrizes < ActiveRecord::Migration[5.2]
  def change
    create_table :tiramon_battle_prizes do |t|
      t.integer :user_id
      t.integer :prize
      t.datetime :datetime

      t.timestamps
    end
  end
end
