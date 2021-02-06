class CardKing < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :last_challenger, class_name: 'User', foreign_key: :last_challenger_id, primary_key: :id, optional: true
  belongs_to :card_deck, optional: true

  def getGeneration
    return CardKing.where(rule: rule).count
  end

  def self.establish(rule = 0)
    new_king = CardKing.new
    new_king.rule = rule
    new_king.user_id = User.none
    new_king.defense = 0
    new_king.save!
  end
end
