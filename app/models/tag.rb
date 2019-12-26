class Tag < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, primary_key: :id
  belongs_to :tweet, foreign_key: :tweet_id, primary_key: :id


  
end
