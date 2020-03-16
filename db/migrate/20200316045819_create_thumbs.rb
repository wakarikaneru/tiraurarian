class CreateThumbs < ActiveRecord::Migration[5.0]
  def change
    create_table :thumbs do |t|
      t.string :key

      t.timestamps
    end
  end
end
