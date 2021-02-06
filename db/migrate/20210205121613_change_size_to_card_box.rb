class ChangeSizeToCardBox < ActiveRecord::Migration[5.2]
  def change
    change_column_default :card_boxes, :size, from: nil, to: 10
  end
end
