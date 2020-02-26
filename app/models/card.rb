class Card < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, primary_key: :id
  belongs_to :user, foreign_key: :model_id, primary_key: :id

  def self.generate(id = 0)
    card = Card.new
    card.user_id = id
    card.model_id = User.offset(rand(User.count)).first.id
    card.element = rand(0..6)
    card.power = ((rand() + rand()) / 2 * 101).floor
    card.create_datetime = Time.current
    card.save!
  end

end
