class ChangeLimitDataToTiramonBattle < ActiveRecord::Migration[5.2]
  def change
    change_column :tiramon_battles, :data, :text, limit: 16777215
  end
end
