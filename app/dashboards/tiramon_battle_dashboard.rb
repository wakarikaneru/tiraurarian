require "administrate/base_dashboard"

class TiramonBattleDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    red_tiramon: Field::BelongsTo.with_options(class_name: "Tiramon"),
    blue_tiramon: Field::BelongsTo.with_options(class_name: "Tiramon"),
    id: Field::Number,
    datetime: Field::DateTime,
    red: Field::Number,
    blue: Field::Number,
    result: Field::Number,
    result_str: Field::String,
    data: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    schedule: Field::DateTime,
    rank: Field::Number,
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
  red
  blue
  result
  result_str
  data
  created_at
  updated_at
  schedule
  rank
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  red_tiramon
  blue_tiramon
  datetime
  red
  blue
  result
  result_str
  data
  schedule
  rank
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
