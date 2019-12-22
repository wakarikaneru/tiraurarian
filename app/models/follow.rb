class Follow < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, primary_key: :id, counter_cache: true
  belongs_to :user, foreign_key: :target_id, primary_key: :id, counter_cache: true

  validates :user_id, uniqueness: { scope: [:target_id] }
end
