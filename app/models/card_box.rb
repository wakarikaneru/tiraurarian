class CardBox < ApplicationRecord
  belongs_to :user

  has_many :cards, foreign_key: :card_box_id, primary_key: :id
  has_many :card_decks, foreign_key: :card_box_id, primary_key: :id

  # カードを購入
  def self.expand?(user = User.none, num = 0)
    unless 0 < num
      return false
    end

    box = CardBox.find_or_create_by(user_id: user.id)
    price = Constants::CARD_BOX_EXPAND_PRICE
    total = price * num
    if user.sub_points?(total)
      for num in 1..num do
        box.size = box.size + 1
      end
      box.save!
      return true
    else
      return false
    end
  end
end
