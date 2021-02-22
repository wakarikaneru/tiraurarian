class AddExperienceToTiramon < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramons, :experience, :integer, default: 0
  end
end
