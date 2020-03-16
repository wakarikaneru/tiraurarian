class CreateThumbJob < ApplicationJob
  queue_as :default

  def perform(key)
    thumb = Thumb.new

    thumb.key = key
    hash = Digest::MD5.hexdigest(key)
    thumb.thumb_from_url("https://www.gravatar.com/avatar/#{hash}?rating=g&default=retro")

    thumb.save!
  end
end
