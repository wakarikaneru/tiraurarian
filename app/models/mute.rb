class Mute < ApplicationRecord
  belongs_to :user
  belongs_to :target, class_name: 'User', foreign_key: :target_id, primary_key: :id

  validates :user_id, uniqueness: { scope: [:target_id] }
end
