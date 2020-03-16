class AddAttachmentThumbToThumbs < ActiveRecord::Migration[5.0]
  def self.up
    change_table :thumbs do |t|
      t.attachment :thumb
    end
  end

  def self.down
    remove_attachment :thumbs, :thumb
  end
end
