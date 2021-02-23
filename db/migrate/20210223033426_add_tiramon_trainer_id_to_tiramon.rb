class AddTiramonTrainerIdToTiramon < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramons, :tiramon_trainer_id, :integer
  end
end
