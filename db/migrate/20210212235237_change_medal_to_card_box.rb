class ChangeMedalToCardBox < ActiveRecord::Migration[5.2]
  def change
    change_column_default :card_boxes, :medal, from: 0, to: 10
  end
end
