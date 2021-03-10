class ChangeLimitDataToTiramonMove < ActiveRecord::Migration[5.2]
  def change
    change_column :tiramon_moves, :data, :text, limit: 16777215
  end
end
