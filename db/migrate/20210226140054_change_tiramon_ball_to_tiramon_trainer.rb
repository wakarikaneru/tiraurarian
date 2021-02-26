class ChangeTiramonBallToTiramonTrainer < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tiramon_trainers, :tiramon_ball, from: 0, to: 1
  end
end
