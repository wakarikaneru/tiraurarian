class CreateStats < ActiveRecord::Migration[5.2]
  def change
    create_table :stats do |t|
      t.datetime :datetime
      t.integer :load
      t.integer :users

      t.timestamps
    end
  end
end
