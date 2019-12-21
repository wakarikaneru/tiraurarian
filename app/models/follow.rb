class Follow < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  belongs_to :user, foreign_key: "target_id"

  validates :user_id, uniqueness: { scope: [:target_id] }
end
