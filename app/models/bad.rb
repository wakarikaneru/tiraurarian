class Bad < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, primary_key: :id
  belongs_to :tweet, foreign_key: :tweet_id, primary_key: :id, counter_cache: :bad_count

  validates :user_id, uniqueness: { scope: [:tweet_id] }
end
