class AddColumnCardBoxes < ActiveRecord::Migration[5.2]
  def change
    add_column :card_boxes, :medal, :integer, default: 0
  end
end
