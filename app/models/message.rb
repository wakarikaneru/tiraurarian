class Message < ApplicationRecord
  before_create :format_content

  belongs_to :user, foreign_key: :user_id, primary_key: :id
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id, primary_key: :id

  validates :content, length: { in: 1..140 }

  private
    def format_content
      self.content.gsub!(/[\r\n|\r|\n]/, " ")
    end
end
