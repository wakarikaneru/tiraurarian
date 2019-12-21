class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tweets, foreign_key: "id"
  has_many :follows, foreign_key: "id"
  has_many :goods, foreign_key: "id"

  validates :name, length: { in: 1..16 }
  validates :description, length: { in: 1..140 }

  has_attached_file :avatar, url: "/system/images/:hash.:extension", hash_secret: "longSecretString", styles: { large: "1024x1024", medium: "512x512", thumb_large: "128x128#", thumb: "64x64#" }, default_url: "/images/noimage.png"
  do_not_validate_attachment_file_type :avatar
end
