class CreateCardGetResults < ActiveRecord::Migration[5.2]
  def change
    create_table :card_get_results do |t|
      t.integer :user_id
      t.integer :card_id

      t.timestamps
    end
  end
end
