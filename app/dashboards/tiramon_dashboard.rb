require "administrate/base_dashboard"

class TiramonDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    tiramon_trainer: Field::BelongsTo,
    id: Field::Number,
    user_id: Field::Number,
    data: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    move: Field::Text,
    experience: Field::Number,
    get_move: Field::Text,
    act: Field::DateTime,
    get_limit: Field::DateTime,
    right: Field::Number,
    training_text: Field::Text,
    rank: Field::Number,
    auto_rank: Field::Number,
    adventure_data: Field::Text,
    adventure_time: Field::DateTime,
    bonus_time: Field::DateTime,
    factor: Field::Text,
    factor_name: Field::String,
    pedigree: Field::Text,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    tiramon_trainer
    id
    user_id
    data
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    tiramon_trainer
    id
    user_id
    data
    created_at
    updated_at
    move
    experience
    get_move
    act
    get_limit
    right
    training_text
    rank
    auto_rank
    adventure_data
    adventure_time
    bonus_time
    factor
    factor_name
    pedigree
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    tiramon_trainer
    user_id
    data
    move
    experience
    get_move
    act
    get_limit
    right
    training_text
    rank
    auto_rank
    adventure_data
    adventure_time
    bonus_time
    factor
    factor_name
    pedigree
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

  # Overwrite this method to customize how tiramons are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(tiramon)
  #   "Tiramon ##{tiramon.id}"
  # end
end
