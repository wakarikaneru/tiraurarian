class CardBox < ApplicationRecord
  belongs_to :user

  has_many :cards, foreign_key: :card_box_id, primary_key: :id
  has_many :card_decks, foreign_key: :card_box_id, primary_key: :id

  # カードBOXを拡張
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

  def add_medals(medal = 0)
    increment!(:medal, medal)
  end

  def sub_medals?(medal = 0)
    if self.medal < medal
      false
    else
      decrement!(:medal, medal)
      true
    end
  end

  def use_trial?()
    if !self.trial
      false
    else
      self.trial = false
      save!
      true
    end
  end

  # お試しガチャ復活
  def self.get_trial
    CardBox.all.update_all(trial: true)
  end
end
