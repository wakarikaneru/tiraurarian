class CardGetResult < ApplicationRecord
  belongs_to :user
  belongs_to :card

  def self.generate(user_id, card_id)
    result = CardGetResult.new
    result.user_id = user_id
    result.card_id = card_id
    result.save!

    return result
  end
end
