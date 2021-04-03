class AddIndexToTiramon < ActiveRecord::Migration[6.1]
  def change
    add_index :tiramons, :tiramon_trainer_id
  end
end
