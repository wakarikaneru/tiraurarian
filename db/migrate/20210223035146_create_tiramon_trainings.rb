class CreateTiramonTrainings < ActiveRecord::Migration[5.2]
  def change
    create_table :tiramon_trainings do |t|
      t.integer :level, default: 0
      t.text :training

      t.timestamps
    end
  end
end
