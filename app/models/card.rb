class Card < ApplicationRecord
  belongs_to :card_box

  has_one :card_deck

  # 表示名
  def displayName
    m = User.find_by(id: model_id)
    if m.present?
      n = m.name
    else
      n =  Constants::CARD_ZOMBIE
    end

    return n
  end

  # 表示名
  def displayNameWithElement
    e = Constants::CARD_ELEMENTS[element]
    m = User.find_by(id: model_id)
    if m.present?
      n = m.name
    else
      n =  Constants::CARD_ZOMBIE
    end

    return "[" + e + "] " + n
  end
  # 表示名
  def displayNameWithAbility
    e = Constants::CARD_ELEMENTS[element]
    p = power.to_s
    m = User.find_by(id: model_id)
    if m.present?
      n = m.name
    else
      n =  Constants::CARD_ZOMBIE
    end

    return "[" + e + "][" + p + "] " + n
  end

  # カードを購入
  def self.purchase?(user = User.none, num = 0)
    unless 0 < num
      return false
    end

    box = CardBox.find_or_create_by(user_id: user.id)
    price = Constants::CARD_PRICE
    total = price * num
    if Card.where(card_box_id: box.id).count + Constants::CARD_PACK * num <= box.size
      if user.sub_points?(total)
        for num in 1..Constants::CARD_PACK * num do
          Card.generate(user.id)
        end
        return true
      else
        return false
      end
    end
  end

  def self.generate(id = 0)
    card_box = CardBox.find_or_create_by(user_id: id)

    card = Card.new
    card.card_box_id = card_box.id
    card.model_id = User.offset(rand(User.count)).first.id
    card.element = rand(1..7)
    card.power = ((rand() + rand()) / 2 * 101).floor
    card.create_datetime = Time.current
    card.save!

    return card
  end

  def self.battle(card_1 = Card.none, card_2 = Card.none)
    ret = {"result": 0, "log": []}

    if card_1.blank? or card_2.blank?
      ret[:result] = 0
      ret[:log].push([0, "試合不成立！"])
    end

    ret[:log].push([0, card_1.displayName + "対" + card_2.displayName + "の試合開始！"])

    card_1_power = card_1.power
    card_2_power = card_2.power

    ret[:log].push([1, card_1.displayName + "の攻撃力は" + card_1_power.to_s + "だ！"])
    ret[:log].push([-1, card_2.displayName + "の攻撃力は" + card_2_power.to_s + "だ！"])

    element_moku_f = Control.find_or_create_by(key: "card_env_moku").value.to_f
    element_ka_f = Control.find_or_create_by(key: "card_env_ka").value.to_f
    element_do_f = Control.find_or_create_by(key: "card_env_do").value.to_f
    element_kin_f = Control.find_or_create_by(key: "card_env_kin").value.to_f
    element_sui_f = Control.find_or_create_by(key: "card_env_sui").value.to_f

    environment = [0, element_moku_f, element_ka_f, element_do_f, element_kin_f, element_sui_f, 0, 0, 0]

    card_1_environment_power = 0
    card_2_environment_power = 0

    environment.length.times { |i|
    	card_1_environment_power += environment[i] * Constants::CARD_ENVIRONMENT[card_1.element][i]
      card_2_environment_power += environment[i] * Constants::CARD_ENVIRONMENT[card_2.element][i]
    }

    #ret[:log].push([1, card_1.displayName + "の環境攻撃力は" + card_1_environment_power.to_s + "だ！"])
    #ret[:log].push([-1, card_2.displayName + "の環境攻撃力は" + card_2_environment_power.to_s + "だ！"])

    card_1_random_power = (rand() - rand()) * 10
    card_2_random_power = (rand() - rand()) * 10

    #ret[:log].push([1, card_1.displayName + "のランダム攻撃力は" + card_1_random_power.to_s + "になった！"])
    #ret[:log].push([-1, card_2.displayName + "のランダム攻撃力は" + card_2_random_power.to_s + "になった！"])

    card_1_effect_power = 0
    card_1_effect = Constants::CARD_EFFFECT[card_1.element][card_2.element]
    if card_1_effect == 1
      ret[:log].push([1, Constants::CARD_ELEMENTS[card_1.element] + "属性は" + Constants::CARD_ELEMENTS[card_2.element] + "属性に対して効果は抜群だ！"])
      card_1_effect_power = 10
    elsif card_1_effect == -1
      ret[:log].push([1, Constants::CARD_ELEMENTS[card_1.element] + "属性は" + Constants::CARD_ELEMENTS[card_2.element] + "属性に対して効果は今ひとつのようだ…"])
      card_1_effect_power = -10
    else
      card_1_effect_power = 0
    end
    #ret[:log].push([1, card_1.displayName + "の属性攻撃力は" + card_1_effect_power.to_s + "だ！"])

    card_2_effect_power = 0
    card_2_effect = Constants::CARD_EFFFECT[card_2.element][card_1.element]
    if card_2_effect == 1
      ret[:log].push([-1, Constants::CARD_ELEMENTS[card_2.element] + "属性は" + Constants::CARD_ELEMENTS[card_1.element] + "属性に対して効果は抜群だ！"])
      card_2_effect_power = 10
    elsif card_2_effect == -1
      ret[:log].push([-1, Constants::CARD_ELEMENTS[card_2.element] + "属性は" + Constants::CARD_ELEMENTS[card_1.element] + "属性に対して効果は今ひとつのようだ…"])
      card_2_effect_power = -10
    else
      card_2_effect_power = 0
    end
    #ret[:log].push([-1, card_2.displayName + "の属性攻撃力は" + card_2_effect_power.to_s + "だ！"])

    card_1_total_power = [(card_1_power + card_1_environment_power + card_1_random_power + card_1_effect_power).floor, 0].max
    card_2_total_power = [(card_2_power + card_2_environment_power + card_2_random_power + card_2_effect_power).floor, 0].max

    ret[:log].push([1, card_1.displayName + "の攻撃力は" + card_1_total_power.to_s + "になった！"])
    ret[:log].push([-1, card_2.displayName + "の攻撃力は" + card_2_total_power.to_s + "になった！"])

    if card_2_total_power < card_1_total_power
      ret[:result] = 1
      ret[:log].push([0, "【挑戦者】" + card_1.displayName + "の勝利！"])
    elsif card_1_total_power < card_2_total_power
      ret[:result] = -1
      ret[:log].push([0, "【王者】" + card_2.displayName + "の勝利！"])
    else
      ret[:result] = 0
      ret[:log].push([0, "引き分け！"])
    end

    return ret
  end

  # 属性変動
  def self.refresh_environment
    element_moku = Control.find_or_create_by(key: "card_env_moku")
    element_ka = Control.find_or_create_by(key: "card_env_ka")
    element_do = Control.find_or_create_by(key: "card_env_do")
    element_kin = Control.find_or_create_by(key: "card_env_kin")
    element_sui = Control.find_or_create_by(key: "card_env_sui")

    element_moku_f = (element_moku.value.to_f * 0.99) + ((rand() - rand()) / 2)
    element_ka_f = (element_ka.value.to_f * 0.99) + ((rand() - rand()) / 2)
    element_do_f = (element_do.value.to_f * 0.99) + ((rand() - rand()) / 2)
    element_kin_f = (element_kin.value.to_f * 0.99) + ((rand() - rand()) / 2)
    element_sui_f = (element_sui.value.to_f * 0.99) + ((rand() - rand()) / 2)

    element_moku.update(value: element_moku_f.to_s)
    element_ka.update(value: element_ka_f.to_s)
    element_do.update(value: element_do_f.to_s)
    element_kin.update(value: element_kin_f.to_s)
    element_sui.update(value: element_sui_f.to_s)
  end

end
