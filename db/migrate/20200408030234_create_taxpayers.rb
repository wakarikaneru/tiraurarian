class CreateTaxpayers < ActiveRecord::Migration[5.2]
  def change
    create_table :taxpayers do |t|
      t.integer :user_id
      t.integer :tax, default: 0

      t.timestamps
    end
  end
end
