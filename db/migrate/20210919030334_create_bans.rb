class CreateBans < ActiveRecord::Migration[6.1]
  def change
    create_table :bans do |t|
      t.string :host
      t.datetime :period

      t.timestamps
    end
  end
end
