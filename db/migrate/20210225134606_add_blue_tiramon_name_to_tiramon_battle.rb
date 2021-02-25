class AddBlueTiramonNameToTiramonBattle < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramon_battles, :blue_tiramon_name, :string
  end
end
