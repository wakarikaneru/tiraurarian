class Card < ApplicationRecord
  belongs_to :card_box, foreign_key: :card_box_id, primary_key: :id
  belongs_to :user, foreign_key: :model_id, primary_key: :id

  def self.generate(id = 0)
    card_box = CardBox.find_or_create_by(user_id: id)

    card = Card.new
    card.card_box_id = card_box.id
    card.model_id = User.offset(rand(User.count)).first.id
    card.element = rand(0..6)
    card.power = ((rand() + rand()) / 2 * 101).floor
    card.create_datetime = Time.current
    card.save!
  end

  # 属性変動
  def self.refresh_environment
    fire = Control.find_or_create_by(key: "card_env_fire")
    air = Control.find_or_create_by(key: "card_env_air")
    earth = Control.find_or_create_by(key: "card_env_earth")
    water = Control.find_or_create_by(key: "card_env_water")

    fire_f = (fire.value.to_f * 0.99) + ((rand() - rand()) / 2)
    air_f = (air.value.to_f * 0.99) + ((rand() - rand()) / 2)
    earth_f = (earth.value.to_f * 0.99) + ((rand() - rand()) / 2)
    water_f = (water.value.to_f * 0.99) + ((rand() - rand()) / 2)

    fire.update(value: fire_f.to_s)
    air.update(value: air_f.to_s)
    earth.update(value: earth_f.to_s)
    water.update(value: water_f.to_s)
  end

end
