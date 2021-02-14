class AddSubElementToCard < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :sub_element, :integer, default: 0
  end
end
