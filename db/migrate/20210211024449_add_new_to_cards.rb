class AddNewToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :new, :boolean, default: false, null: false
  end
end
