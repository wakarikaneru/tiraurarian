class CardBox < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, primary_key: :id

  has_many :cards, foreign_key: :card_box_id, primary_key: :id
  has_many :card_decks, foreign_key: :card_box_id, primary_key: :id

end
