class AddPaymentTimeToTiramonBattle < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramon_battles, :payment_time, :datetime
  end
end
