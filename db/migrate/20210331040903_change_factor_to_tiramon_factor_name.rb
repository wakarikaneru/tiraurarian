class ChangeFactorToTiramonFactorName < ActiveRecord::Migration[6.1]
  def change
    change_column :tiramon_factor_names, :factor, :text, limit: 4294967285
  end
end
