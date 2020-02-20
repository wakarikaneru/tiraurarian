class Mute < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, primary_key: :id
  belongs_to :user, foreign_key: :target_id, primary_key: :id

  validates :user_id, uniqueness: { scope: [:target_id] }
end
