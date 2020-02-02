class RenameTargetIdColumnToGoods < ActiveRecord::Migration[5.0]
  def change
    rename_column :goods, :target_id, :tweet_id
  end
end
