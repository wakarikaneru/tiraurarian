class CreateTiramonTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :tiramon_templates do |t|
      t.integer :level
      t.string :name
      t.text :data

      t.timestamps
    end
  end
end
