class AddColumnCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :rare, :boolean, default: false, null: false
  end
end
