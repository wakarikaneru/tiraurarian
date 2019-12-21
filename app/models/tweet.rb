class Tweet < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  belongs_to :tweet, foreign_key: "parent_id", optional: true
  has_many :goods, foreign_key: "id"

  validates :content, length: { in: 1..140 }

  has_attached_file :image, url: "/system/images/:hash.:extension", hash_secret: "longSecretString", styles: { large: "1024x1024", medium: "512x512", thumb_large: "128x128#", thumb: "64x64#" }, default_url: "/images/null.png"
  do_not_validate_attachment_file_type :image
end
