class CreateNews < ActiveRecord::Migration[5.2]
  def change
    create_table :news do |t|
      t.integer :priority
      t.datetime :expiration
      t.string :news

      t.timestamps
    end
  end
end
