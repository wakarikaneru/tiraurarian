class Thumb < ApplicationRecord
  has_attached_file :thumb, url: "/system/images/:hash.:extension", hash_secret: "longSecretString", styles: { thumb_large: "128x128#", thumb: "64x64#" }, default_url: "/images/mystery-person.png"
  do_not_validate_attachment_file_type :thumb

  validates :key, uniqueness: true

  def thumb_from_url(url)
    self.thumb = open(url)
  end
end
