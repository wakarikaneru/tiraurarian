class Text < ApplicationRecord

  belongs_to :user
  belongs_to :tweet

  validates :content, {presence: true, length: {maximum: 10000}}
end
