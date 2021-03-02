class ChangeMoveToTiramonTrainer < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tiramon_trainers, :move, from: 0, to: 3
  end
end
