class CreateTiramonEnemies < ActiveRecord::Migration[5.2]
  def change
    create_table :tiramon_enemies do |t|
      t.integer :enemy_class
      t.integer :stage
      t.integer :enemy_id
      t.string :name
      t.text :data

      t.timestamps
    end
  end
end
