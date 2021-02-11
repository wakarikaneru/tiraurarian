class CardGetResult < ApplicationRecord
  belongs_to :user
  belongs_to :card

  def self.generate(user_id, cards = Card.none)
    results = []

    cards.map do |card|
      result = CardGetResult.new
      result.user_id = user_id
      result.card_id = card.id
      results << result
    end

    CardGetResult.import(results)
    return results
  end

end
