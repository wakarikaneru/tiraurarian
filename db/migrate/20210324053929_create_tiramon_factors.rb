class CreateTiramonFactors < ActiveRecord::Migration[6.1]
  def change
    create_table :tiramon_factors do |t|
      t.string :key
      t.text :factor

      t.timestamps
    end
  end
end
