class Notice < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, primary_key: :id

  
end
