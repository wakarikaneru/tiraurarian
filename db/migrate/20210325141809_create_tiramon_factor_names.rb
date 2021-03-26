class CreateTiramonFactorNames < ActiveRecord::Migration[6.1]
  def change
    create_table :tiramon_factor_names do |t|
      t.string :key
      t.text :factor, limit: 16777215

      t.timestamps
    end
  end
end
