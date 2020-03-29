class Good < ApplicationRecord
  belongs_to :user
  belongs_to :tweet, counter_cache: :good_count

  validates :user_id, uniqueness: { scope: [:tweet_id] }
end
