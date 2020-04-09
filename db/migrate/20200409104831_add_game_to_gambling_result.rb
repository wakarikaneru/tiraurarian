class AddGameToGamblingResult < ActiveRecord::Migration[5.2]
  def change
    add_column :gambling_results, :game, :string
  end
end
