class Admin < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, primary_key: :id

  validates :user_id, uniqueness: true
end
