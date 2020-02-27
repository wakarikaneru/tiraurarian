class CardDeck < ApplicationRecord
  belongs_to :card_box, foreign_key: :card_box_id, primary_key: :id

end
