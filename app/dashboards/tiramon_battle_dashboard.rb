require "administrate/base_dashboard"

class TiramonBattleDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    red_tiramon: Field::BelongsTo,
    blue_tiramon: Field::BelongsTo,
    id: Field::Number,
    datetime: Field::DateTime,
    result: Field::Number,
    result_str: Field::String,
    data: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    schedule: Field::DateTime,
    rank: Field::Number,
    payment: Field::Boolean,
    payment_time: Field::DateTime,
    red_tiramon_name: Field::String,
    blue_tiramon_name: Field::String,
    match_time: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    red_tiramon
    blue_tiramon
    id
    datetime
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    red_tiramon
    blue_tiramon
    id
    datetime
    result
    result_str
    data
    created_at
    updated_at
    schedule
    rank
    payment
    payment_time
    red_tiramon_name
    blue_tiramon_name
    match_time
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    red_tiramon
    blue_tiramon
    datetime
    result
    result_str
    data
    schedule
    rank
    payment
    payment_time
    red_tiramon_name
    blue_tiramon_name
    match_time
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

  # Overwrite this method to customize how tiramon battles are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(tiramon_battle)
  #   "TiramonBattle ##{tiramon_battle.id}"
  # end
end
