class CreateTaxpayerHofs < ActiveRecord::Migration[5.2]
  def change
    create_table :taxpayer_hofs do |t|
      t.integer :user_id
      t.integer :tax, default: 0
      t.datetime :datetime

      t.timestamps
    end
  end
end
