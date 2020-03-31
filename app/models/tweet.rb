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

  def set_sensitivity(request)
    if self.image?
      require "google/cloud/vision"

      image_annotator = Google::Cloud::Vision::ImageAnnotator.new
      likelihood = Google::Cloud::Vision::V1::Likelihood

      image_path = URI.join(request.url, self.image.url(:large)).to_s

      response = image_annotator.safe_search_detection image: image_path
      score = 0.0

      response.responses.each do |res|
        safe_search = res.safe_search_annotation

        unless safe_search.nil?
          adult = likelihood.const_get(safe_search.adult).to_f / likelihood::VERY_LIKELY
          spoof = likelihood.const_get(safe_search.spoof).to_f / likelihood::VERY_LIKELY
          medical = likelihood.const_get(safe_search.medical).to_f / likelihood::VERY_LIKELY
          violence = likelihood.const_get(safe_search.violence).to_f / likelihood::VERY_LIKELY
          racy = likelihood.const_get(safe_search.racy).to_f / likelihood::VERY_LIKELY

          score = [score, adult, spoof, medical, violence, racy].max
        end
      end

      self.sensitivity = score
      return
    else
      self.sensitivity = 0.0
      return
    end
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
