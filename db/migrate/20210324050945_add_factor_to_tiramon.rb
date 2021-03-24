class AddFactorToTiramon < ActiveRecord::Migration[6.1]
  def change
    add_column :tiramons, :factor, :text
    add_column :tiramons, :factor_name, :string
  end
end
