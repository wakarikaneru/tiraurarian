class AddIndexToCard < ActiveRecord::Migration[6.1]
  def change
    add_index :cards, :card_box_id
    add_index :cards, :model_id
    add_index :cards, :element
    add_index :cards, :power
    add_index :cards, :create_datetime
    add_index :cards, :new
  end
end
