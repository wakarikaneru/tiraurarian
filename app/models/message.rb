class Message < ApplicationRecord
  before_create :format_content

  belongs_to :user, foreign_key: :user_id, primary_key: :id
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id, primary_key: :id

  validates :content, length: { in: 1..140 }

  # メッセージ生成
  def self.generate(user_id = 0, sender_id = 0, sender_name = "チラウラリア", content = "")
    message = Message.new
    message.user_id = user_id
    message.sender_id = sender_id
    message.sender_name = sender_name
    message.content = content
    message.read_flag = false
    message.create_datetime = Time.current

    message.save!
  end

  private
    def format_content
      self.content.gsub!(/[\r\n|\r|\n]/, " ")
    end
end
