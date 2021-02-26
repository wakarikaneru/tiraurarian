class AddAutoRankToTiramon < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramons, :auto_rank, :integer
  end
end
