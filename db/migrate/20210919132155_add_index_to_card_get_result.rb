class AddIndexToCardGetResult < ActiveRecord::Migration[6.1]
  def change
    add_index :card_get_results, :user_id
    add_index :card_get_results, :card_id
  end
end
