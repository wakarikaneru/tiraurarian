class Tweet < ApplicationRecord
  include Twitter::TwitterText::Extractor

  before_create :format_content, :set_context

  belongs_to :user, foreign_key: :user_id, primary_key: :id
  belongs_to :parent, class_name: 'Tweet', foreign_key: :parent_id, primary_key: :id, counter_cache: :res_count, optional: true
  has_many :tweets, foreign_key: :parent_id, primary_key: :id
  has_many :goods
  has_many :bads
  has_many :bookmarks
  has_many :tags

  validates :content, length: { in: 1..140 }

  has_attached_file :image, url: "/system/images/:hash.:extension", hash_secret: "longSecretString", styles: { large: "1024x1024>", medium: "512x512>", thumb_large: "640x360#", thumb: "64x64#" }, default_url: "/images/null.png"
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
