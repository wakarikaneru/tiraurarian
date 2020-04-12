class CreateTiramonBattles < ActiveRecord::Migration[5.2]
  def change
    create_table :tiramon_battles do |t|
      t.datetime :datetime
      t.integer :red
      t.integer :blue
      t.integer :result
      t.string :result_str
      t.text :data

      t.timestamps
    end
  end
end
