class AddGetLimitToTiramon < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramons, :get_limit, :datetime
  end
end
