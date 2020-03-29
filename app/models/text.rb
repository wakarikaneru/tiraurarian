class Text < ApplicationRecord

  belongs_to :user
  belongs_to :tweet

  validates :content, length: { in: 1..10000 }
end
