class CardDeck < ApplicationRecord
  validate :validate_deck

  belongs_to :card_box

  belongs_to :card_1, class_name: 'Card', foreign_key: :card_1_id, primary_key: :id
  belongs_to :card_2, class_name: 'Card', foreign_key: :card_2_id, primary_key: :id
  belongs_to :card_3, class_name: 'Card', foreign_key: :card_3_id, primary_key: :id

  def getCard(isShuffle = false)
    cards = []
    cards[0] = card_1
    cards[1] = card_2
    cards[2] = card_3

    if isShuffle then
      return cards.shuffle
    else
      return cards
    end
  end

  def getTotalPower()
    powers = []
    powers[0] = card_1.power
    powers[1] = card_2.power
    powers[2] = card_3.power

    return powers.sum
  end

  def isContainGod?()
    elements = []
    elements[0] = card_1.element
    elements[1] = card_2.element
    elements[2] = card_3.element

    return elements.include?(11)
  end

  def isValid?(user = User.none, rule = 0)
    unless user == card_box.user
      return false
    end

    if card_1_id.blank? or card_2_id.blank? or card_3_id.blank?
      return false
    end

    return getTotalPower() <= Constants::CARD_RULE[rule]
  end

  def isKing?
    king0 = CardKing.where(rule: 0).order(id: :desc).first
    king1 = CardKing.where(rule: 1).order(id: :desc).first
    king2 = CardKing.where(rule: 2).order(id: :desc).first

    if id == king0.card_deck_id or id == king1.card_deck_id or id == king2.card_deck_id
      return true
    else
      return false
    end
  end

  def validate_deck
    if card_1_id.blank? or card_2_id.blank? or card_3_id.blank?
      return
    end

    unless card_box_id == Card.find_by(id: card_1_id).card_box_id
      errors.add(:card_1, "BOX外のカードを使うことはできません")
    end
    unless card_box_id == Card.find_by(id: card_2_id).card_box_id
      errors.add(:card_1, "BOX外のカードを使うことはできません")
    end
    unless card_box_id == Card.find_by(id: card_3_id).card_box_id
      errors.add(:card_1, "BOX外のカードを使うことはできません")
    end

    arr = [card_1_id, card_2_id, card_3_id]
    if arr.uniq.size < 3
      errors.add(:card_deck, "同じカードを複数使うことはできません")
    end
  end
end
