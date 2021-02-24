class AddTrainingMessageToTiramon < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramons, :training_text, :text
  end
end
