class CreatePoints < ActiveRecord::Migration[5.0]
  def change
    create_table :points do |t|
      t.integer :user_id
      t.integer :point, default: 0

      t.timestamps
    end
  end
end
