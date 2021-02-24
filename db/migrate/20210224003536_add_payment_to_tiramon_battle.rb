class AddPaymentToTiramonBattle < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramon_battles, :payment, :boolean, default: false, null: false
  end
end
