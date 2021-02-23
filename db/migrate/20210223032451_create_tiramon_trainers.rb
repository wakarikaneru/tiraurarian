class CreateTiramonTrainers < ActiveRecord::Migration[5.2]
  def change
    create_table :tiramon_trainers do |t|
      t.integer :user_id
      t.integer :level, default: 0
      t.integer :experience, default: 0
      t.integer :tiramon_ball, default: 0

      t.timestamps
    end
  end
end
