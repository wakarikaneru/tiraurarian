class Notice < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, primary_key: :id
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id, primary_key: :id

end
