class ChangeDefenceToCardKing < ActiveRecord::Migration[5.2]
  def change
    change_column_default :card_kings, :defense, from: nil, to: 0
  end
end
