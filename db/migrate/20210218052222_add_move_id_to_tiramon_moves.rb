class AddMoveIdToTiramonMoves < ActiveRecord::Migration[5.2]
  def change
    add_column :tiramon_moves, :move_id, :integer
  end
end
