class AddAttachmentAvatarToTweets < ActiveRecord::Migration[5.0]
  def self.up
    change_table :tweets do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :tweets, :avatar
  end
end
