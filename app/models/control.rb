class Control < ApplicationRecord
  validates :key, uniqueness: true
end
