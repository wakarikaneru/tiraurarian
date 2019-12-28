class User < ApplicationRecord
  before_create :format_description
  before_update :format_description

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: :login_id

  has_many :tweets
  has_many :follows
  has_many :goods
  has_many :tags

  validates :login_id, presence: true, uniqueness: true, length: { in: 1..16 }
  validates :name, length: { in: 1..16 }
  validates :description, length: { maximum: 140 }

  has_attached_file :avatar, url: "/system/images/:hash.:extension", hash_secret: "longSecretString", styles: { large: "1024x1024", medium: "512x512", thumb_large: "128x128#", thumb: "64x64#" }, default_url: "/images/noimage.png"
  do_not_validate_attachment_file_type :avatar

  def email_required?
    false
  end

  def email_changed?
    false
  end

  private
    def format_description
      self.description.gsub!(/[\r\n|\r|\n]/, " ")
    end
end
