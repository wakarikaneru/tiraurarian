class CreateControls < ActiveRecord::Migration[5.0]
  def change
    create_table :controls do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
