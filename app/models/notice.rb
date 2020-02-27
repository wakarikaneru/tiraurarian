class Notice < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, primary_key: :id
  belongs_to :user, foreign_key: :sender_id, primary_key: :id

end
