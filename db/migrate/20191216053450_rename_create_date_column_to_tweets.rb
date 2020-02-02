class RenameCreateDateColumnToTweets < ActiveRecord::Migration[5.0]
  def change
    rename_column :tweets, :create_date, :create_datetime
  end
end
