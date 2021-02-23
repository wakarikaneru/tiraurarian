class AddMoveToTiramonTrainer < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramon_trainers, :move, :integer, default: 0
  end
end
