class Premium < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true

  def self.generate(user_id = 0)
    premium = Premium.find_or_create_by(user_id: user_id)
    premium.limit_datetime = Time.current.since(Constants::PREMIUM_LIMIT)
    premium.create_datetime = Time.current
    premium.save!
  end
end
