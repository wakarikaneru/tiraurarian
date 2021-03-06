class Card < ApplicationRecord
  belongs_to :card_box

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

  # 自分のカードか判定
  def isOwn?(user = User.none)
    return card_box.user == user
  end

  # ゾンビ判定
  def isZombie?
    m = User.find_by(id: model_id)
    if m.present?
      return false
    else
      return true
    end
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
        Card.generate(user.id, Constants::CARD_PACK * num)
        return true
      else
        return false
      end
    end
    return false
  end

  # メダルでカードを購入
  def self.gacha?(user = User.none, num = 0)
    unless 0 < num
      return false
    end

    box = CardBox.find_or_create_by(user_id: user.id)
    if Card.where(card_box_id: box.id).count + num <= box.size
      if box.sub_medals?(num)
        Card.generateRare(user.id, num)
        return true
      else
        return false
      end
    end
    return false
  end

  # お試しガチャ
  def self.trialGacha?(user = User.none)

    box = CardBox.find_or_create_by(user_id: user.id)
    if Card.where(card_box_id: box.id).count + 1 <= box.size
      if box.use_trial?()
        Card.generateRare(user.id, 1)
        return true
      else
        return false
      end
    end
    return false
  end

  # カードを鑑定する
  def judge?(user = User.none)
    box = CardBox.find_or_create_by(user_id: user.id)
    price = Constants::CARD_JUDGE_PRICE
    if self.element == 9
      if user.sub_points?(price)
        if rand() < 0.01.to_f
          self.element = rand(10..11)
        else
          self.element = rand(0..9)
        end
        if rand() < 0.1.to_f
          self.sub_element = rand(10..11)
        else
          self.sub_element = rand(0..8)
        end
        self.rare = true
        self.new = true
        self.save!
        return true
      else
        return false
      end
    end
    return false
  end

  # カードを送信する
  def send?(user = User.none, target_user = User.none)
    price = Constants::CARD_SEND_PRICE
    if isOwn?(user)
      if user.sub_points?(price)
        self.card_box = CardBox.find_or_create_by(user_id: target_user.id)
        self.new = true
        self.save!
        return true
      else
        return false
      end
    end
    return false
  end

  def self.generate(id = 0, num = 0)
    card_box = CardBox.find_or_create_by(user_id: id)

    cards = []
    num.times do
      card = Card.new
      card.card_box_id = card_box.id
      card.model_id = User.offset(rand(User.count)).first.id
      card.element = rand(1..7)
      if rand() < 0.001.to_f
        card.sub_element = rand(10..11)
      else
        card.sub_element = rand(0..8)
      end
      card.power = ((rand() + rand()) / 2 * 101).floor
      card.rare = rand() < 0.01.to_f
      card.new = true
      card.create_datetime = Time.current
      cards << card
    end
    Card.import(cards)

    return cards
  end

  def self.generateRare(id = 0, num = 0)
    card_box = CardBox.find_or_create_by(user_id: id)

    cards = []
    num.times do
      card = Card.new
      card.card_box_id = card_box.id
      card.model_id = User.offset(rand(User.count)).first.id
      if rand() < 0.1.to_f
        card.element = 9
      else
        card.element = rand(1..7)
      end
      if rand() < 0.01.to_f
        card.sub_element = rand(10..11)
      else
        card.sub_element = rand(0..8)
      end
      card.power = (rand() * 101).floor
      card.rare = rand() < 0.1.to_f
      card.new = true
      card.create_datetime = Time.current
      cards << card
    end
    Card.import(cards)

    return cards
  end

  def self.getEnvironmentText
    # 環境をテキストで表示する
    element_moku_f = Control.find_or_create_by(key: "card_env_moku").value.to_f
    element_ka_f = Control.find_or_create_by(key: "card_env_ka").value.to_f
    element_do_f = Control.find_or_create_by(key: "card_env_do").value.to_f
    element_kin_f = Control.find_or_create_by(key: "card_env_kin").value.to_f
    element_sui_f = Control.find_or_create_by(key: "card_env_sui").value.to_f

    environment = [0, element_moku_f, element_ka_f, element_do_f, element_kin_f, element_sui_f, 0, 0, 0, 0, 0, 0]
    max_element = environment.index(environment.max)
    max_element_name = Constants::CARD_ELEMENTS[max_element]

    if 10 < environment.max
      return "≪" + max_element_name + "≫の気が極限まで高まっている…！！！"
    elsif 5 < environment.max
      return "≪" + max_element_name + "≫の気が最高潮まで高まっている…！！"
    elsif 2.5 < environment.max
      return "≪" + max_element_name + "≫の気がかなり高まっている…！"
    elsif 1 < environment.max
      return "≪" + max_element_name + "≫の気が高まっている…"
    end

    if environment.sum < 0
      return "辺りは異様に静かだ…"
    end

    return ""
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

    # 調子
    card_1_random_power = (rand() - rand()) * 10
    if 5 < card_1_random_power
      ret[:log].push([1, card_1.displayName + "は絶好調だ！"])
    elsif 2.5 < card_1_random_power
      ret[:log].push([1, card_1.displayName + "は調子が良さそうだ！"])
    end
    if card_1_random_power < -5
      ret[:log].push([1, card_1.displayName + "は絶不調のようだ…"])
    elsif card_1_random_power < -2.5
      ret[:log].push([1, card_1.displayName + "は調子が悪そうだ…"])
    end

    card_2_random_power = (rand() - rand()) * 10
    if 5 < card_2_random_power
      ret[:log].push([-1, card_2.displayName + "は絶好調だ！"])
    elsif 2.5 < card_2_random_power
      ret[:log].push([-1, card_2.displayName + "は調子が良さそうだ！"])
    end
    if card_2_random_power < -5
      ret[:log].push([-1, card_2.displayName + "は絶不調のようだ…"])
    elsif card_2_random_power < -2.5
      ret[:log].push([-1, card_2.displayName + "は調子が悪そうだ…"])
    end

    #ret[:log].push([1, card_1.displayName + "のランダム攻撃力は" + card_1_random_power.to_s + "になった！"])
    #ret[:log].push([-1, card_2.displayName + "のランダム攻撃力は" + card_2_random_power.to_s + "になった！"])


    card_1_element = card_1.element
    card_1_sub_element = card_1.sub_element
    card_2_element = card_2.element
    card_2_sub_element = card_2.sub_element

    # 副属性発現
    if card_1.element != card_1.sub_element
      if rand() < 0.01
        card_1_element = card_1.sub_element
        ret[:log].push([1, card_1.displayName + "の隠された能力が目覚めた！"])
        ret[:log].push([1, card_1.displayName + "は" + Constants::CARD_ELEMENTS[card_1_element] + "属性に変化した！"])
      end
    end
    if card_2.element != card_2.sub_element
      if rand() < 0.01
        card_2_element = card_2.sub_element
        ret[:log].push([-1, card_2.displayName + "の隠された能力が目覚めた！"])
        ret[:log].push([-1, card_2.displayName + "は" + Constants::CARD_ELEMENTS[card_2_element] + "属性に変化した！"])
      end
    end

    # 環境の影響
    element_moku_f = Control.find_or_create_by(key: "card_env_moku").value.to_f
    element_ka_f = Control.find_or_create_by(key: "card_env_ka").value.to_f
    element_do_f = Control.find_or_create_by(key: "card_env_do").value.to_f
    element_kin_f = Control.find_or_create_by(key: "card_env_kin").value.to_f
    element_sui_f = Control.find_or_create_by(key: "card_env_sui").value.to_f

    environment = [0, element_moku_f, element_ka_f, element_do_f, element_kin_f, element_sui_f, 0, 0, 0, 0, 0, 0]

    card_1_environment_power = 0
    card_2_environment_power = 0

    environment.length.times { |i|
    	card_1_environment_power += environment[i] * Constants::CARD_ENVIRONMENT[card_1_element][i]
      card_2_environment_power += environment[i] * Constants::CARD_ENVIRONMENT[card_2_element][i]
    }

    #ret[:log].push([1, card_1.displayName + "の環境攻撃力は" + card_1_environment_power.to_s + "だ！"])
    #ret[:log].push([-1, card_2.displayName + "の環境攻撃力は" + card_2_environment_power.to_s + "だ！"])

    # 属性の相性
    card_1_effect_power = 0
    card_1_effect = Constants::CARD_EFFFECT[card_1_element][card_2_element]
    card_1_sub_effect = Constants::CARD_EFFFECT[card_1_sub_element][card_2_element]
    if card_1_effect == 1
      ret[:log].push([1, Constants::CARD_ELEMENTS[card_1_element] + "属性は" + Constants::CARD_ELEMENTS[card_2_element] + "属性に対して効果は抜群だ！"])
      card_1_effect_power = 10
    elsif card_1_effect == -1
      ret[:log].push([1, Constants::CARD_ELEMENTS[card_1_element] + "属性は" + Constants::CARD_ELEMENTS[card_2_element] + "属性に対して効果は今ひとつのようだ…"])
      card_1_effect_power = -10
    else
      card_1_effect_power = 0
    end
    if card_1_sub_effect == 1
      card_1_effect_power += 1
    elsif card_1_sub_effect == -1
      card_1_effect_power += -1
    else
      card_1_effect_power += 0
    end
    #ret[:log].push([1, card_1.displayName + "の属性攻撃力は" + card_1_effect_power.to_s + "だ！"])

    card_2_effect_power = 0
    card_2_effect = Constants::CARD_EFFFECT[card_2_element][card_1_element]
    card_2_sub_effect = Constants::CARD_EFFFECT[card_2_sub_element][card_1_element]
    if card_2_effect == 1
      ret[:log].push([-1, Constants::CARD_ELEMENTS[card_2_element] + "属性は" + Constants::CARD_ELEMENTS[card_1_element] + "属性に対して効果は抜群だ！"])
      card_2_effect_power = 10
    elsif card_2_effect == -1
      ret[:log].push([-1, Constants::CARD_ELEMENTS[card_2_element] + "属性は" + Constants::CARD_ELEMENTS[card_1_element] + "属性に対して効果は今ひとつのようだ…"])
      card_2_effect_power = -10
    else
      card_2_effect_power = 0
    end
    if card_2_sub_effect == 1
      card_2_effect_power += 1
    elsif card_2_sub_effect == -1
      card_2_effect_power += -1
    else
      card_2_effect_power += 0
    end
    #ret[:log].push([-1, card_2.displayName + "の属性攻撃力は" + card_2_effect_power.to_s + "だ！"])

    # 召喚
    card_1_summon_power = 0
    if !(card_1_element == 10 or card_1_element == 11) and !card_1.isZombie?
      if rand() < 0.1
        ret[:log].push([1, card_1.displayName + "は精霊を召喚しようとしている…"])
        if rand() < 0.1
          ret[:log].push([1, card_1.displayName + "は精霊≪" + Constants::CARD_ELEMENTALS[card_1_element] + "≫を召喚した！！"])
          card_1_summon_power = 100
        else
          ret[:log].push([1, card_1.displayName + "は精霊の召喚に失敗した…"])
        end
      end
    end

    card_2_summon_power = 0
    if !(card_2_element == 10 or card_2_element == 11) and !card_2.isZombie?
      if rand() < 0.1
        ret[:log].push([-1, card_2.displayName + "は精霊を召喚しようとしている…"])
        if rand() < 0.1
          ret[:log].push([-1, card_2.displayName + "は精霊≪" + Constants::CARD_ELEMENTALS[card_2_element] + "≫を召喚した！！"])
          card_2_summon_power = 100
        else
          ret[:log].push([-1, card_2.displayName + "は精霊の召喚に失敗した…"])
        end
      end
    end

    # 合計
    card_1_total_power = [(card_1_power + card_1_environment_power + card_1_random_power + card_1_effect_power + card_1_summon_power).floor, 0].max
    card_2_total_power = [(card_2_power + card_2_environment_power + card_2_random_power + card_2_effect_power + card_2_summon_power).floor, 0].max

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
