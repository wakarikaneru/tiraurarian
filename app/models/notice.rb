class Notice < ApplicationRecord
  belongs_to :user
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id, primary_key: :id

  # 通知生成
  def self.generate(user_id = 0, sender_id = 0, sender_name = "チラウラリア", content = "")
    notice = Notice.new
    notice.user_id = user_id
    notice.sender_id = sender_id
    notice.sender_name = sender_name
    notice.content = content
    notice.read_flag = false
    notice.create_datetime = Time.current

    notice.save!
  end

  # 一斉送信
  def self.broadcast(sender_id = 0, sender_name = "チラウラリア", content = "")
    User.all.find_each do |user|
      Notice.generate(user.id, sender_id, sender_name, content)
    end
  end

end
