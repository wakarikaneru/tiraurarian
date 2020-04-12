class CreateTiramons < ActiveRecord::Migration[5.2]
  def change
    create_table :tiramons do |t|
      t.integer :user_id
      t.text :data

      t.timestamps
    end
  end
end
