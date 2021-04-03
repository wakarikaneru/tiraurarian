class Tweet < ApplicationRecord
  include Twitter::TwitterText::Extractor

  before_create :format_content, :set_context, :set_translate, :set_sensitivity
  after_create :tweet_after

  belongs_to :user
  belongs_to :parent, class_name: 'Tweet', foreign_key: :parent_id, primary_key: :id, counter_cache: :res_count, optional: true
  has_many :tweets, foreign_key: :parent_id, primary_key: :id
  has_one :text, dependent: :destroy
  has_many :goods, dependent: :destroy
  has_many :wakarus, dependent: :destroy
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

  def content_selected_language(language)
    case language
      when "ja" then
        if self.language == language || self.language_confidence <= 0.99
          return self.content
        else
          return get_native_content(language)
        end
      when "en" then
        if self.language == language || self.language_confidence <= 0.99
          return self.content
        else
          return get_native_content(language)
        end
      when "zh-CN" then
        if self.language == language || self.language_confidence <= 0.99
          return self.content
        else
          return get_native_content(language)
        end
      when "ru" then
        if self.language == language || self.language_confidence <= 0.99
          return self.content
        else
          return get_native_content(language)
        end
      else
        return self.content
    end
  end

  def get_native_content(language)
    case language
      when "ja" then
        unless self.content_ja.blank?
          return self.content_ja
        else
          return self.content
        end
      when "en" then
        unless self.content_en.blank?
          return self.content_en
        else
          return self.content
        end
      when "zh-CN" then
        unless self.content_zh.blank?
          return self.content_zh
        else
          return self.content
        end
      when "ru" then
        unless self.content_ru.blank?
          return self.content_ru
        else
          return self.content
        end
      else
        return self.content
    end
  end

  private
    def format_content
      self.content.gsub!(/[\r\n|\r|\n]/, " ")
    end

    def set_context
      if Tweet.find_by(id: self.parent_id).present?
        self.context = Tweet.find(self.parent_id).context + 1
      else
        self.context = 0
      end
    end

    def set_sensitivity
      if self.image?
        require "google/cloud/vision"

        image_annotator = Google::Cloud::Vision.image_annotator
        likelihood = Google::Cloud::Vision::V1::Likelihood

        response = image_annotator.safe_search_detection image: self.image.staged_path(:large)
        score = 0.0

        response.responses.each do |res|
          safe_search = res.safe_search_annotation

          adult = likelihood.const_get(safe_search.adult).to_f / likelihood::VERY_LIKELY
          spoof = likelihood.const_get(safe_search.spoof).to_f / likelihood::VERY_LIKELY
          medical = likelihood.const_get(safe_search.medical).to_f / likelihood::VERY_LIKELY
          violence = likelihood.const_get(safe_search.violence).to_f / likelihood::VERY_LIKELY
          racy = likelihood.const_get(safe_search.racy).to_f / likelihood::VERY_LIKELY

          score = [score, adult, spoof, medical, violence, racy].max

          self.adult = [self.adult, likelihood.const_get(safe_search.adult)].max
          self.spoof = [self.spoof, likelihood.const_get(safe_search.spoof)].max
          self.medical = [self.medical, likelihood.const_get(safe_search.medical)].max
          self.violence = [self.violence, likelihood.const_get(safe_search.violence)].max
          self.racy = [self.racy, likelihood.const_get(safe_search.racy)].max
        end

        self.sensitivity = score

        if likelihood::LIKELY.to_f / likelihood::VERY_LIKELY.to_f <= self.sensitivity
          self.nsfw = true
        end
      else
        self.sensitivity = 0.0
      end

    end

    def set_translate
      require "google/cloud/translate"

      translate_v2 = Google::Cloud::Translate.translation_v2_service project_id: "tirauraria"

      content = self.content

      detection = translate_v2.detect content
      self.language = detection.language
      self.language_confidence = detection.confidence

      Constants::TRANSLATE_LANGUAGE.each do |language|
        case language
          when "ja" then
            translation = translate_v2.translate content, to: language
            self.content_ja = CGI.unescapeHTML(translation.text)
          when "en" then
            translation = translate_v2.translate content, to: language
            self.content_en = CGI.unescapeHTML(translation.text)
          when "zh" then
            translation = translate_v2.translate content, to: language
            self.content_zh = CGI.unescapeHTML(translation.text)
          when "ru" then
            translation = translate_v2.translate content, to: language
            self.content_ru = CGI.unescapeHTML(translation.text)
        end

      end

    end

    def tweet_after
      extract_hashtags(self.content).uniq.map do |tag|
        Tag.find_or_create_by(user_id: self.user_id, tweet_id: self.id, tag_string: tag, create_datetime: Time.current)
      end
      User.find_by(id: self.user_id).update_last_tweet()
      User.find_by(id: self.user_id).add_points(1)
    end

end
