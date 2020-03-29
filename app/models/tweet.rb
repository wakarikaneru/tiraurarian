class Tweet < ApplicationRecord
  include Twitter::TwitterText::Extractor

  before_create :format_content, :set_context

  belongs_to :user
  belongs_to :parent, class_name: 'Tweet', foreign_key: :parent_id, primary_key: :id, counter_cache: :res_count, optional: true
  has_many :tweets, foreign_key: :parent_id, primary_key: :id
  has_one :text, dependent: :destroy
  has_many :goods, dependent: :destroy
  has_many :bads, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :tags, dependent: :destroy

  validates :content, length: { in: 1..140 }

  accepts_nested_attributes_for :text

  has_attached_file :image, url: "/system/images/:hash.:extension", hash_secret: "longSecretString", styles: { large: "1024x1024>", medium: "512x512>", thumb_large: "640x360#", thumb: "64x64#" }, default_url: "/images/no-image.png"
  do_not_validate_attachment_file_type :image

  has_attached_file :avatar, url: "/system/images/:hash.:extension", hash_secret: "longSecretString", styles: { thumb: "64x64#" }, default_url: "/images/no-image.png"
  do_not_validate_attachment_file_type :avatar

  def image_from_url(url)
    self.image = open(url)
  end

  def avatar_from_url(url)
    self.avatar = open(url)
  end

  after_create do
    extract_hashtags(self.content).uniq.map do |tag|
      Tag.find_or_create_by(user_id: self.user_id, tweet_id: self.id, tag_string: tag, create_datetime: Time.current)
    end
    User.find_by(id: self.user_id).update_last_tweet()
    User.find_by(id: self.user_id).add_points(1)
  end

  private
    def format_content
      self.content.gsub!(/[\r\n|\r|\n]/, " ")
    end

    def set_context
      self.context = Tweet.find(self.parent_id).context + 1
    end
end
