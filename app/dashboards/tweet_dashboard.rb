require "administrate/base_dashboard"

class TweetDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    host: Field::String,
    ip: Field::String,
    user: Field::BelongsTo,
    parent: Field::BelongsTo,
    tweets: Field::HasMany,
    text: Field::HasOne,
    goods: Field::HasMany,
    bads: Field::HasMany,
    bookmarks: Field::HasMany,
    tags: Field::HasMany,
    id: Field::Number,
    content: Field::String,
    create_datetime: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    image_file_name: Field::String,
    image_content_type: Field::String,
    image_file_size: Field::Number,
    image_updated_at: Field::DateTime,
    res_count: Field::Number,
    good_count: Field::Number,
    bookmark_count: Field::Number,
    avatar_file_name: Field::String,
    avatar_content_type: Field::String,
    avatar_file_size: Field::Number,
    avatar_updated_at: Field::DateTime,
    bad_count: Field::Number,
    context: Field::Number,
    nsfw: Field::Boolean,
    humanity: Field::Number.with_options(decimals: 2),
    sensitivity: Field::Number.with_options(decimals: 2),
    adult: Field::Number,
    spoof: Field::Number,
    medical: Field::Number,
    violence: Field::Number,
    racy: Field::Number,
    content_ja: Field::String,
    content_en: Field::String,
    content_zh: Field::String,
    language: Field::String,
    language_confidence: Field::Number.with_options(decimals: 2),
    content_ru: Field::String,
    content_ko: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    user
    parent
    tweets
    text
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    host
    ip
    user
    parent
    tweets
    text
    goods
    bads
    bookmarks
    tags
    id
    content
    create_datetime
    created_at
    updated_at
    image_file_name
    image_content_type
    image_file_size
    image_updated_at
    res_count
    good_count
    bookmark_count
    avatar_file_name
    avatar_content_type
    avatar_file_size
    avatar_updated_at
    bad_count
    context
    nsfw
    humanity
    sensitivity
    adult
    spoof
    medical
    violence
    racy
    content_ja
    content_en
    content_zh
    language
    language_confidence
    content_ru
    content_ko
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    host
    ip
    user
    parent
    tweets
    text
    goods
    bads
    bookmarks
    tags
    content
    create_datetime
    image_file_name
    image_content_type
    image_file_size
    image_updated_at
    res_count
    good_count
    bookmark_count
    avatar_file_name
    avatar_content_type
    avatar_file_size
    avatar_updated_at
    bad_count
    context
    nsfw
    humanity
    sensitivity
    adult
    spoof
    medical
    violence
    racy
    content_ja
    content_en
    content_zh
    language
    language_confidence
    content_ru
    content_ko
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how tweets are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(tweet)
  #   "Tweet ##{tweet.id}"
  # end
end
