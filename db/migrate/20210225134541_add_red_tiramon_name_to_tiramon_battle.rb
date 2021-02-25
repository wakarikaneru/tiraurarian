class AddRedTiramonNameToTiramonBattle < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramon_battles, :red_tiramon_name, :string
  end
end
