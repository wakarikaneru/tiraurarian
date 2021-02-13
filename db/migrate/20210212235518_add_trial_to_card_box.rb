class AddTrialToCardBox < ActiveRecord::Migration[5.2]
  def change
    add_column :card_boxes, :trial, :boolean, default: true, null: false
  end
end
