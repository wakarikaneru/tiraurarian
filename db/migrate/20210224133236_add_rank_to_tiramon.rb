class AddRankToTiramon < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramons, :rank, :integer, default: 3
  end
end
