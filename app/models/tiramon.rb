class Tiramon < ApplicationRecord
  belongs_to :tiramon_trainer, optional: true

  def self.generate(trainer = TiramonTrainer.none, min_level = 0, max_level = 20)
    tiramon = Tiramon.new
    tiramon.data = Tiramon.generateData(min_level, max_level).to_json

    move_list = TiramonMove.first.getData
    tiramon.move = Tiramon.get_moves(tiramon.getData)
    tiramon.get_move = move_list.pluck(:id).sample(rand(3..6)).sort.difference(Tiramon.get_moves(tiramon.getData))

    tiramon.rank = 6
    tiramon.experience = 0
    tiramon.act = Time.current - Constants::TIRAMON_TRAINING_TERM_MAX
    tiramon.get_limit = 30.minute.since
    tiramon.right = trainer.id
    tiramon.bonus_time = Constants::TIRAMON_TRAINING_BONUS_TIME.since

    tiramon.generate_factor
    tiramon.factor_name = Tiramon.get_factor_name(tiramon)

    tiramon.save!
    return tiramon
  end

  def self.fusion(trainer = TiramonTrainer.none, t_1, t_2)
    tiramon = Tiramon.new

    # 因子の融合
    tiramon.fusion_factor(t_1.getFactor, t_2.getFactor)
    tiramon.factor_name = Tiramon.get_factor_name(tiramon)

    # 能力の融合
    tiramon.data = tiramon.fusionData(t_1, t_2).to_json

    move_list = TiramonMove.first.getData
    tiramon.move = (Tiramon.get_moves(tiramon.getData) + t_1.getMove + t_2.getMove).uniq.sort
    tiramon.get_move = move_list.pluck(:id).sample(rand(3..6)).sort.difference(Tiramon.get_moves(tiramon.getData))

    tiramon.rank = 5
    tiramon.experience = 0
    tiramon.act = Time.current - Constants::TIRAMON_TRAINING_TERM_MAX
    tiramon.get_limit = 30.minute.since
    tiramon.bonus_time = Constants::TIRAMON_TRAINING_BONUS_TIME.since

    tiramon.tiramon_trainer_id = trainer.id

    # 血統を記録する
    d_1 = t_1.getData
    d_2 = t_2.getData
    tiramon.pedigree = [[[t_1.getFactorName, d_1[:name]], [t_1.getPedigree[0][0], t_1.getPedigree[1][0]]], [[t_2.getFactorName, d_2[:name]], [t_2.getPedigree[0][0], t_2.getPedigree[1][0]]]].to_json

    tiramon.save!
    return tiramon
  end

  def generate_factor
    require "matrix"
    data = self.getData

    arr = Array.new(100){ rand(-1.0..1.0) }
    base_factor = Vector.elements(arr)

    self.factor = base_factor.normalize.to_json
  end

  def fusion_factor(f_1, f_2)
    require "matrix"
    data = self.getData

    a_1 = f_1.to_a
    a_2 = f_2.to_a

    #arr = Array.new(100){|index| [a_1[index], a_2[index]].sample }
    arr = Array.new(100){|index| a_1[index] + a_2[index] }
    base_factor = Vector.elements(arr)
    base_factor += TiramonFactor.find_by(key: "god").getFactor * 0.1

    self.factor = base_factor.normalize.to_json
  end

  def self.get_factor_name(tiramon)
    f = tiramon.getFactor

    list = TiramonFactorName.first.getFactorNameList
    match = list.max_by { |x| f.dot(x[1]) }
    return match[0]
  end

  def get?(trainer = TiramonTrainer.none)
    if right == trainer.id and Time.current < get_limit
      if trainer.use_ball?
        update(right: nil, tiramon_trainer_id: trainer.id, bonus_time: 30.minute.since)
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def self.fusion_get?(trainer = TiramonTrainer.none, t_1, t_2)
    if (t_1.tiramon_trainer_id == trainer.id and t_1.can_act?) and (t_2.tiramon_trainer_id == trainer.id and t_2.can_act?) and (20 <= t_1.get_level and 20 <= t_2.get_level) and t_1 != t_2
      if trainer.use_ball?
        Tiramon.fusion(trainer, t_1, t_2)
        t_1.update(tiramon_trainer_id: nil)
        t_2.update(tiramon_trainer_id: nil)
        return true
      else
        return false
      end
    end
    return false
  end

  def self.generateData(min_level, max_level)
    min_power = min_level / 100.0
    max_power = max_level / 100.0

    template = TiramonTemplate.where(level: 0..10).sample
    data = template.getData

    data[:name] = Gimei.male.kanji
    data[:physique] = 1 + 0.50 * Tiramon.dist_rand_2(3)
    data[:bmi] = (25.0 + 5.0 * Tiramon.dist_rand(2)) * data[:physique]
    data[:height] = 1.75 + (0.50 * Tiramon.dist_rand_2(3))
    data[:weight] = data[:height] ** 2 * data[:bmi]

    data[:abilities][:vital] = [100 + 50 * Tiramon.dist_rand(2), 100 + 50 * Tiramon.dist_rand(2), 100 + 50 * Tiramon.dist_rand(2)]
    data[:abilities][:recovery] = [100 + 50 * Tiramon.dist_rand(2), 100 + 50 * Tiramon.dist_rand(2), 100 + 50 * Tiramon.dist_rand(2)]
    data[:abilities][:speed] = 100 + 50 * Tiramon.dist_rand(2)
    data[:abilities][:intuition] = Tiramon.power_rand(3)
    data[:skills][:attack] = [1 + 0.5 * Tiramon.dist_rand(1), 1 + 0.5 * Tiramon.dist_rand(1), 1 + 0.5 * Tiramon.dist_rand(1)]
    data[:skills][:defense] = [1 + 0.5 * Tiramon.dist_rand(1), 1 + 0.5 * Tiramon.dist_rand(1), 1 + 0.5 * Tiramon.dist_rand(1)]

    data[:train][:abilities][:vital] = [0.5 + rand(min_power..max_power), 0.5 + rand(min_power..max_power), 0.5 + rand(min_power..max_power)]
    data[:train][:abilities][:recovery] = [0.5 + rand(min_power..max_power), 0.5 + rand(min_power..max_power), 0.5 + rand(min_power..max_power)]
    data[:train][:abilities][:speed] = 0.5 + rand(min_power..max_power)
    data[:train][:abilities][:intuition] = 0.5 + rand()
    data[:train][:skills][:attack] = [0.5 + rand(min_power..max_power), 0.5 + rand(min_power..max_power), 0.5 + rand(min_power..max_power)]
    data[:train][:skills][:defense] = [0.5 + rand(min_power..max_power), 0.5 + rand(min_power..max_power), 0.5 + rand(min_power..max_power)]

    data[:train][:level] = Tiramon.getLevel(data)

    return data
  end

  def fusionData(t_1, t_2, min_level = 0, max_level = 5)
    f = self.getFactor

    d_1 = t_1.getData
    d_2 = t_2.getData

    template = TiramonTemplate.where(level: 0..10).sample
    data = template.getData

    data[:name] = Gimei.male.kanji
    if rand() < f.dot(TiramonFactor.find_by(key: "physique").getFactor) * 2
      data[:physique] = [d_1[:physique], d_2[:physique]].max
    else
      data[:physique] = [d_1[:physique], d_2[:physique]].sample
    end
    data[:bmi] = (25.0 + 5.0 * Tiramon.dist_rand(2)) * data[:physique]
    if rand() < f.dot(TiramonFactor.find_by(key: "height").getFactor) * 2
      data[:height] = [d_1[:height], d_2[:height]].max + (0.05 * Tiramon.dist_rand_2(2))
    else
      data[:height] = [d_1[:height], d_2[:height]].sample + (0.05 * Tiramon.dist_rand_2(2))
    end
    data[:weight] = data[:height] ** 2 * data[:bmi]

    if rand() < f.dot(TiramonFactor.find_by(key: "vital_hp").getFactor) * 2
      data[:abilities][:vital][0] = [d_1[:abilities][:vital][0], d_2[:abilities][:vital][0]].max
    else
      data[:abilities][:vital][0] = [d_1[:abilities][:vital][0], d_2[:abilities][:vital][0]].sample
    end
    if rand() < f.dot(TiramonFactor.find_by(key: "vital_mp").getFactor) * 2
      data[:abilities][:vital][1] = [d_1[:abilities][:vital][1], d_2[:abilities][:vital][1]].max
    else
      data[:abilities][:vital][1] = [d_1[:abilities][:vital][1], d_2[:abilities][:vital][1]].sample
    end
    if rand() < f.dot(TiramonFactor.find_by(key: "vital_sp").getFactor) * 2
      data[:abilities][:vital][2] = [d_1[:abilities][:vital][2], d_2[:abilities][:vital][2]].max
    else
      data[:abilities][:vital][2] = [d_1[:abilities][:vital][2], d_2[:abilities][:vital][2]].sample
    end
    if rand() < f.dot(TiramonFactor.find_by(key: "speed").getFactor) * 2
      data[:abilities][:speed] = [d_1[:abilities][:speed], d_2[:abilities][:speed]].max
    else
      data[:abilities][:speed] = [d_1[:abilities][:speed], d_2[:abilities][:speed]].sample
    end
    if rand() < f.dot(TiramonFactor.find_by(key: "intuition").getFactor) * 2
      data[:abilities][:intuition] = [d_1[:abilities][:intuition], d_2[:abilities][:intuition]].max
    else
      data[:abilities][:intuition] = [d_1[:abilities][:intuition], d_2[:abilities][:intuition]].sample
    end
    if rand() < f.dot(TiramonFactor.find_by(key: "recovery_hp").getFactor) * 2
      data[:abilities][:recovery][0] = [d_1[:abilities][:recovery][0], d_2[:abilities][:recovery][0]].max
    else
      data[:abilities][:recovery][0] = [d_1[:abilities][:recovery][0], d_2[:abilities][:recovery][0]].sample
    end
    if rand() < f.dot(TiramonFactor.find_by(key: "recovery_mp").getFactor) * 2
      data[:abilities][:recovery][1] = [d_1[:abilities][:recovery][1], d_2[:abilities][:recovery][1]].max
    else
      data[:abilities][:recovery][1] = [d_1[:abilities][:recovery][1], d_2[:abilities][:recovery][1]].sample
    end
    if rand() < f.dot(TiramonFactor.find_by(key: "recovery_sp").getFactor) * 2
      data[:abilities][:recovery][2] = [d_1[:abilities][:recovery][2], d_2[:abilities][:recovery][2]].max
    else
      data[:abilities][:recovery][2] = [d_1[:abilities][:recovery][2], d_2[:abilities][:recovery][2]].sample
    end
    if rand() < f.dot(TiramonFactor.find_by(key: "attack_0").getFactor) * 2
      data[:skills][:attack][0] = [d_1[:skills][:attack][0], d_2[:skills][:attack][0]].max
    else
      data[:skills][:attack][0] = [d_1[:skills][:attack][0], d_2[:skills][:attack][0]].sample
    end
    if rand() < f.dot(TiramonFactor.find_by(key: "attack_1").getFactor) * 2
      data[:skills][:attack][1] = [d_1[:skills][:attack][1], d_2[:skills][:attack][1]].max
    else
      data[:skills][:attack][1] = [d_1[:skills][:attack][1], d_2[:skills][:attack][1]].sample
    end
    if rand() < f.dot(TiramonFactor.find_by(key: "attack_2").getFactor) * 2
      data[:skills][:attack][2] = [d_1[:skills][:attack][2], d_2[:skills][:attack][2]].max
    else
      data[:skills][:attack][2] = [d_1[:skills][:attack][2], d_2[:skills][:attack][2]].sample
    end
    if rand() < f.dot(TiramonFactor.find_by(key: "defense_0").getFactor) * 2
      data[:skills][:defense][0] = [d_1[:skills][:defense][0], d_2[:skills][:defense][0]].max
    else
      data[:skills][:defense][0] = [d_1[:skills][:defense][0], d_2[:skills][:defense][0]].sample
    end
    if rand() < f.dot(TiramonFactor.find_by(key: "defense_1").getFactor) * 2
      data[:skills][:defense][1] = [d_1[:skills][:defense][1], d_2[:skills][:defense][1]].max
    else
      data[:skills][:defense][1] = [d_1[:skills][:defense][1], d_2[:skills][:defense][1]].sample
    end
    if rand() < f.dot(TiramonFactor.find_by(key: "defense_2").getFactor) * 2
      data[:skills][:defense][2] = [d_1[:skills][:defense][2], d_2[:skills][:defense][2]].max
    else
      data[:skills][:defense][2] = [d_1[:skills][:defense][2], d_2[:skills][:defense][2]].sample
    end

    level = ([d_1[:train][:level], d_2[:train][:level]].sum / 2) * ((1 + f.dot(TiramonFactor.find_by(key: "level").getFactor)) / 2)
    min_power = [(level / 100) - (0.1 * rand()), 0.0].max
    max_power = [(level / 100) + (0.1 * rand()), 0.0].max

    data[:train][:abilities][:vital] = [0.5 + rand(min_power..max_power), 0.5 + rand(min_power..max_power), 0.5 + rand(min_power..max_power)]
    data[:train][:abilities][:recovery] = [0.5 + rand(min_power..max_power), 0.5 + rand(min_power..max_power), 0.5 + rand(min_power..max_power)]
    data[:train][:abilities][:speed] = 0.5 + rand(min_power..max_power)
    data[:train][:abilities][:intuition] = 0.5 + rand(min_power..max_power)
    data[:train][:skills][:attack] = [0.5 + rand(min_power..max_power), 0.5 + rand(min_power..max_power), 0.5 + rand(min_power..max_power)]
    data[:train][:skills][:defense] = [0.5 + rand(min_power..max_power), 0.5 + rand(min_power..max_power), 0.5 + rand(min_power..max_power)]

    data[:train][:level] = Tiramon.getLevel(data)

    return data
  end

  def self.getLevel(data)
    a = []
    a.concat(data[:train][:abilities][:vital])
    a.concat(data[:train][:abilities][:recovery])
    a << data[:train][:abilities][:speed]
    a << data[:train][:abilities][:intuition]
    a.concat(data[:train][:skills][:attack])
    a.concat(data[:train][:skills][:defense])

    return (a.sum(0.0) / a.length) * 100 - 50
  end

  def self.getQuality(data)
    a = []
    a.concat(data[:abilities][:vital])
    a.concat(data[:abilities][:recovery])
    a << data[:abilities][:speed]
    a << data[:abilities][:intuition] * 100 + 50
    a << data[:skills][:attack][0] * 100
    a << data[:skills][:attack][1] * 100
    a << data[:skills][:attack][2] * 100
    a << data[:skills][:defense][0] * 100
    a << data[:skills][:defense][1] * 100
    a << data[:skills][:defense][2] * 100

    return ((a.sum(0.0) / a.length) - 50) / 100
  end

  def getData
    if data.present?
      return eval(data)
    else
      return {}
    end
  end

  def getMove
    if move.present?
      return eval(move)
    else
      return []
    end
  end

  def getGetMove
    if get_move.present?
      return eval(get_move)
    else
      return []
    end
  end

  def getFactor
    require 'matrix'
    if factor.present?
      return Vector.elements(eval(factor))
    else
      return {}
    end
  end

  def getFactorName
    d = self.getData
    return (self.factor_name.present? and 20 <= d[:train][:level]) ? self.factor_name : "?"
  end

  def getPedigree
    require 'matrix'
    if pedigree.present?
      return eval(pedigree)
    else
      return [[["?", "?"], [["?", "?"], ["?", "?"]]], [["?", "?"], [["?", "?"], ["?", "?"]]]]
    end
  end

  def getTrainingText
    if training_text.present?
      return eval(training_text)
    else
      return {}
    end
  end

  def getAdventureData
    if adventure_data.present?
      return eval(adventure_data)
    else
      return {level:{}, stage:{}, enemy:{}}
    end
  end

  def self.getBattleData(d)
    t = {
      name: d[:name],
      level: d[:train][:level],
      height: d[:height].to_f,
      weight: d[:weight].to_f,
      bmi: d[:bmi].to_f,
      max_hp: d[:abilities][:vital][0].to_f * d[:train][:abilities][:vital][0].to_f,
      max_mp: d[:abilities][:vital][1].to_f * d[:train][:abilities][:vital][1].to_f,
      max_sp: d[:abilities][:vital][2].to_f * d[:train][:abilities][:vital][2].to_f,
      recovery_hp: d[:abilities][:recovery][0].to_f * d[:train][:abilities][:recovery][0].to_f,
      recovery_mp: d[:abilities][:recovery][1].to_f * d[:train][:abilities][:recovery][1].to_f,
      recovery_sp: d[:abilities][:recovery][2].to_f * d[:train][:abilities][:recovery][2].to_f,
      hp: d[:abilities][:vital][0].to_f * d[:train][:abilities][:vital][0].to_f,
      mp: d[:abilities][:vital][1].to_f * d[:train][:abilities][:vital][1].to_f,
      sp: d[:abilities][:vital][2].to_f * d[:train][:abilities][:vital][2].to_f,
      temp_hp: d[:abilities][:vital][0].to_f * d[:train][:abilities][:vital][0].to_f,
      temp_mp: d[:abilities][:vital][1].to_f * d[:train][:abilities][:vital][1].to_f,
      temp_sp: d[:abilities][:vital][2].to_f * d[:train][:abilities][:vital][2].to_f,
      speed: d[:abilities][:speed].to_f * d[:train][:abilities][:speed].to_f,
      intuition: d[:abilities][:intuition].to_f * d[:train][:abilities][:intuition].to_f,
      attack: d[:skills][:attack],
      defense: d[:skills][:defense],
      tactics: d[:style][:tactics],
      study: [0, 0, 0],
      flexible: [0, 0, 0],
      wary: d[:style][:wary],
      moves: d[:moves],
      ko: false,
    }

    t[:level] = Tiramon.getLevel(d)
    t[:quality] = Tiramon.getQuality(d)
    t[:bmi] = t[:weight] / (t[:height] ** 2)
    t[:attack] = [d[:skills][:attack][0] * d[:train][:skills][:attack][0], d[:skills][:attack][1] * d[:train][:skills][:attack][1], d[:skills][:attack][2] * d[:train][:skills][:attack][2]]
    t[:defense] = [d[:skills][:defense][0] * d[:train][:skills][:defense][0], d[:skills][:defense][1] * d[:train][:skills][:defense][1], d[:skills][:defense][2] * d[:train][:skills][:defense][2]]

    return t
  end

  def self.about(n = 0, a = 1)
    return (n / a).round * a
  end

  def self.battle(tiramon_1_data, tiramon_2_data)
    require "matrix"

    move_list = TiramonMove.first.getData

    ret = {"result": 0, "time": 0, "log": []}

    # 選手入場
    ret[:log].push([4, -Constants::TIRAMON_ENTRANCE_TIME])
    ret[:log].push([4, 0])

    if tiramon_1_data.blank? or tiramon_2_data.blank?
      ret[:result] = 0
      ret[:log].push([0, "試合不成立！"])
    end

    ret[:log].push([0, "選手入場！！！"])

    t_1 = Tiramon.getBattleData(tiramon_1_data)
    t_2 = Tiramon.getBattleData(tiramon_2_data)

    ret[:log].push([-1, "赤コーナー！"])
    ret[:log].push([-1, (t_2[:height] * 100).to_i.to_s + "センチ " + (t_2[:weight]).to_i.to_s + "kg！"])
    ret[:log].push([-1, t_2[:name] + "！！！"])

    ret[:log].push([5, [-1, t_2.clone]])
    ret[:log].push([0, "歓声が上がる！！！"])


    ret[:log].push([1, "青コーナー！"])
    ret[:log].push([1, (t_1[:height] * 100).to_i.to_s + "センチ " + (t_1[:weight]).to_i.to_s + "kg！"])
    ret[:log].push([1, t_1[:name] + "！！！"])

    ret[:log].push([5, [1, t_1.clone]])
    ret[:log].push([0, "歓声が上がる！！！"])


    # 勝負は試合の前から始まっている…
    t_1[:study] = (Vector.elements(t_2[:attack]).normalize).to_a
    t_2[:study] = (Vector.elements(t_1[:attack]).normalize).to_a


    ret[:log].push([0, "…"])

    # 試合開始
    ret[:log].push([4, 0])

    ret[:log].push([0, "60分1本勝負！"])
    ret[:log].push([0, t_1[:name] + " 対 " + t_2[:name] + "！"])

    ret[:log].push([2, [t_1.clone, t_2.clone]])

    ret[:log].push([0,  "試合開始！"])
    ret[:log].push([0,  "ゴングが鳴った！！！"])


    draw = false
    turn = 0
    last_turn = 0
    combo = 1
    turn_count = 0
    time_count = 0.second
    last_move = ""
    while !t_1[:ko] and !t_2[:ko] and !draw

      # 時間経過
      time_count += 30.second
      ret[:log].push([4, time_count])
      if 60.minute <= time_count
        draw = true
      end

      turn_count += 1

      if turn_count % 1 == 0
        ret[:log].push([2, [t_1.clone, t_2.clone]])
      end

      t_1_move_power_hp = [t_1[:temp_hp] / t_1[:max_hp], 0.0].max
      t_1_move_power_sp = [t_1[:temp_sp] / t_1[:max_sp], 0.0].max
      t_2_move_power_hp = [t_2[:temp_hp] / t_2[:max_hp], 0.0].max
      t_2_move_power_sp = [t_2[:temp_sp] / t_2[:max_sp], 0.0].max

      t_1_weight = t_1[:weight]
      t_2_weight = t_2[:weight]

      t_1_weight_balance = [t_2_weight / t_1_weight, 2.0, 0.5].sort.second
      t_2_weight_balance = [t_1_weight / t_2_weight, 2.0, 0.5].sort.second
      #ret[:log].push([1, t_1_weight_balance])
      #ret[:log].push([-1, t_2_weight_balance])

      t_1_height = t_1[:height]
      t_2_height = t_2[:height]

      t_1_height_balance = [t_2_height / t_1_height, 2.0, 0.5].sort.second
      t_2_height_balance = [t_1_height / t_2_height, 2.0, 0.5].sort.second
      #ret[:log].push([1, t_1_height_balance])
      #ret[:log].push([-1, t_2_height_balance])

      t_1_pride = Tiramon.get_pride(t_1)
      t_2_pride = Tiramon.get_pride(t_2)

      t_1_motivation = [t_2_pride / t_1_pride, 2.0, 0.5].sort.second
      t_2_motivation = [t_1_pride / t_2_pride, 2.0, 0.5].sort.second
      #ret[:log].push([1, t_1_motivation])
      #ret[:log].push([-1, t_2_motivation])

      ret[:log].push([1, Tiramon.get_message(Constants::TIRAMON_MOTIVATION, t_1_motivation / 2)])
      ret[:log].push([-1, Tiramon.get_message(Constants::TIRAMON_MOTIVATION, t_2_motivation / 2)])


      t_1_move_power = [t_1[:speed] * t_1_move_power_sp * t_1_weight_balance * t_1_height_balance * t_1_motivation, 0.0].max
      t_2_move_power = [t_2[:speed] * t_2_move_power_sp * t_2_weight_balance * t_2_height_balance * t_2_motivation, 0.0].max

      #ret[:log].push([1, t_1_move_power.to_s + "行動力！"])
      #ret[:log].push([-1, t_2_move_power.to_s + "行動力！"])

      if t_1_move_power <= 0 and t_2_move_power <= 0
        turn = 0
      elsif rand() * (t_1_move_power + t_2_move_power) < t_1_move_power
        # 1のターン
        turn = 1
        attacker = t_1
        defender = t_2
      else
        # 2のターン
        turn = -1
        attacker = t_2
        defender = t_1
      end

      if turn == 0

        last_turn = turn

        ret[:log].push([turn, Tiramon.get_message(Constants::TIRAMON_DOUBLE_DOWN, rand())])

        # お互い寝っ転がりっぱなしはしょっぱいのでスタミナ回復
        # BMIが異常なほどスタミナ回復が遅い
        t_1_bmi_damage = [((22.0 - t_1[:bmi]).abs / 18.0) * 0.5, -0.5, 0.0].sort.second
        t_2_bmi_damage = [((22.0 - t_2[:bmi]).abs / 18.0) * 0.5, -0.5, 0.0].sort.second
        t_1_recovery_power = (t_1[:sp] / t_1[:max_sp]) * t_1[:recovery_sp] * (1 - t_1_bmi_damage)
        t_2_recovery_power = (t_2[:sp] / t_2[:max_sp]) * t_2[:recovery_sp] * (1 - t_2_bmi_damage)

        t_1_recovery = 1
        t_2_recovery = 1
        if t_2_recovery_power < t_1_recovery_power
          t_1_recovery = t_1_recovery_power / t_1_recovery_power
          t_2_recovery = t_2_recovery_power / t_1_recovery_power
        else
          t_1_recovery = t_1_recovery_power / t_2_recovery_power
          t_2_recovery = t_2_recovery_power / t_2_recovery_power
        end

        t_1_sp = -t_1[:temp_sp]
        t_2_sp = -t_2[:temp_sp]

        t_1_sp_recover = t_1_sp / t_2_recovery
        t_2_sp_recover = t_2_sp / t_1_recovery

        t_1[:temp_sp] += t_1_sp_recover
        t_2[:temp_sp] += t_2_sp_recover

      elsif 0 < attacker[:temp_sp]

        # 仕掛ける
        ret[:log].push([turn, attacker[:name] + Tiramon.get_message(Constants::TIRAMON_MOVE, rand())])

        attacker_hp = [((1 - attacker[:temp_hp] / attacker[:max_hp]) * 4).to_i, 3].min
        defender_hp = [((1 - defender[:temp_hp] / defender[:max_hp]) * 4).to_i, 3].min
        weight_effect = (attacker[:weight].to_f / defender[:weight].to_f)
        combo_effect = 1 + (combo - 1) * 0.2

        moves = attacker[:moves][attacker_hp][defender_hp]
        move = moves.sample

        move_data = TiramonMove.getMoveData(move_list.find{|m| m[:id] == move})
        last_move = move_data[:name]

        #ret[:log].push([turn, move_data[:name] + "を狙っている！"])

        damage = {hp: 0.0, thp: 0.0, mp: 0.0, tmp: 0.0, sp: 0.0, tsp: 0.0}

        3.times { |element|
          skill_effect = (attacker[:attack][element].to_f / defender[:defense][element].to_f)
        	damage[:hp] += move_data[:damage][:hp][element].to_f * skill_effect * weight_effect
        	damage[:thp] += move_data[:damage][:thp][element].to_f * skill_effect * weight_effect
        	damage[:mp] += move_data[:damage][:mp][element].to_f * skill_effect * weight_effect
        	damage[:tmp] += move_data[:damage][:tmp][element].to_f * skill_effect * weight_effect
        	damage[:sp] += move_data[:damage][:sp][element].to_f * skill_effect * weight_effect
        	damage[:tsp] += move_data[:damage][:tsp][element].to_f * skill_effect * weight_effect
        }
        #ret[:log].push([turn, "攻撃の威力は" + damage.to_s ])

        damage_physical = damage[:hp] + damage[:thp]
        if 0 < damage_physical

          ret[:log].push([turn, "[" + Constants::TIRAMON_ELEMENTS[move_data[:element]] + "]属性の行動のようだ！"])

          damage_pride = Tiramon.get_pride(defender) / 5
          damage_risk = Tiramon.get_risk(damage)

          # 攻撃の要素を分類
          damage_element = []
          damage_element[0] = move_data[:damage][:element_0]
          damage_element[1] = move_data[:damage][:element_1]
          damage_element[2] = move_data[:damage][:element_2]
          damage_vector = Vector.elements(damage_element)
          #ret[:log].push([turn, "攻撃は" + damage_vector.to_s ])

          # 命中率の計算
          # 攻撃側の技の属性
          attack_vector = Vector.elements(damage_element)
          attack_vector = attack_vector.zero? ? attack_vector : attack_vector.normalize
          #ret[:log].push([turn, "攻撃属性は" + attack_vector.to_s ])

          # 守備側の構え
          # 体力に応じて回避力が下がる
          avoid_hp = [defender[:temp_hp] / defender[:max_hp], 1.0, 0.0].sort.second
          avoid_sp = [defender[:temp_sp] / defender[:max_sp], 1.0, 0.0].sort.second

          # プロレス的なところ
          pride = Tiramon.get_pride(defender) / 5
          #ret[:log].push([-turn, "慢心度は" + pride.to_i.to_s ])
          #ret[:log].push([-turn, "恐怖度は" + damage_risk.to_i.to_s ])
          fear = [damage_risk / pride, 2.0, 0.0].sort.second
          #ret[:log].push([-turn, "回避率(恐怖)" + ((fear) * 100).to_i.to_s + "%" ])
          #ret[:log].push([-turn, "回避率倍率(体力)" + ((avoid_hp) * 100).to_i.to_s + "%" ])
          avoid_puroresu = [fear * avoid_hp, 0.90, 0.10].sort.second

          # シュート
          # 勘
          intuition = [[defender[:intuition], 0.0].max, 1.0].min
          intuition_vector = (Vector.elements(attack_vector) * (intuition) + Vector.elements([rand(), rand(), rand()]).normalize * (1 - intuition))
          intuition_vector = intuition_vector.zero? ? intuition_vector : intuition_vector.normalize
          #ret[:log].push([-turn, "勘は" + intuition_vector.to_s ])

          # 相手に合わせて
          study_vector = Vector.elements(defender[:study])
          study_vector = study_vector.zero? ? study_vector : study_vector.normalize
          #ret[:log].push([-turn, "研究は" + study_vector.to_s ])

          # 試合中の経験
          flexible_vector = Vector.elements(defender[:flexible])
          flexible_vector = flexible_vector.zero? ? flexible_vector : flexible_vector.normalize
          #ret[:log].push([-turn, "経験は" + flexible_vector.to_s ])

          # 作戦
          wary_vector = Vector.elements(defender[:wary])
          wary_vector = wary_vector.zero? ? wary_vector : wary_vector.normalize
          #ret[:log].push([-turn, "警戒は" + wary_vector.to_s ])

          defence_vector = intuition_vector * defender[:tactics][:intuition] + study_vector * defender[:tactics][:study] + flexible_vector * defender[:tactics][:flexible] + wary_vector * defender[:tactics][:wary]
          defence_vector = defence_vector.zero? ? defence_vector : defence_vector.normalize
          #ret[:log].push([-turn, "防御属性は" + defence_vector.to_s ])

          defence_array = defence_vector.to_a
          ret[:log].push([-turn, "[" + Constants::TIRAMON_ELEMENTS[defence_array.index(defence_array.max)] + "]属性を警戒している！"])

          wariness = attack_vector.dot(defence_vector)

          # 臨機応変に対応する
          defender[:flexible] = (flexible_vector + damage_vector).normalize * defender[:max_hp]

          #ret[:log].push([-turn, "回避率(読み合い)" + ((wariness) * 100).to_i.to_s + "%" ])
          #ret[:log].push([-turn, "回避率倍率(体力)" + ((avoid_hp) * 100).to_i.to_s + "%" ])
          #ret[:log].push([-turn, "回避率倍率(スタミナ)" + ((avoid_sp) * 100).to_i.to_s + "%" ])
          avoid_shoot = [wariness * avoid_sp, 0.99, 0.01].sort.second

          #ret[:log].push([-turn, "回避率(プロレス)" + ((avoid_puroresu) * 100).to_i.to_s + "%" ])
          #ret[:log].push([-turn, "回避率(シュート)" + ((avoid_shoot) * 100).to_i.to_s + "%" ])

          ret[:log].push([turn, Tiramon.get_message(Constants::TIRAMON_RISK, (damage_risk / damage_pride))])
          ret[:log].push([turn, move_data[:name] + "を狙っている！"])

          avoid_array = [avoid_puroresu, avoid_shoot]
          fail_index = avoid_array.index(avoid_array.max)
          fail = avoid_array.max

          #ret[:log].push([turn, "命中率" + ((1 - fail) * 100).to_i.to_s + "%" ])

          if fail_index == 0
            ret[:log].push([turn, Tiramon.get_message(Constants::TIRAMON_HIT_RATE_PURORESU, (1 - fail))])
          elsif fail_index ==1
            ret[:log].push([turn, Tiramon.get_message(Constants::TIRAMON_HIT_RATE_SHOOT, (1 - fail))])
          end

        else
          fail = 0
        end

        if rand() < fail
          # 攻撃がかわされた
          ret[:log].push([turn, Tiramon.get_message(Constants::TIRAMON_FAIL_ATTACK, rand())])

          # SP消費
          attacker[:sp] -= attacker[:sp] / 40.0
          attacker[:temp_sp] -= attacker[:temp_sp] / 2.0
          # SP回復
          # defender[:temp_sp] += (defender[:sp] - [defender[:temp_sp], 0.0].max) / 2.0

        else

          if last_turn == turn
            combo += 1
          else
            combo = 1
          end
          last_turn = turn

          ret[:log].push([turn, move_data[:name] + Tiramon.get_message(Constants::TIRAMON_SUCCESS_ATTACK, rand())])

          # ダメージを与える
          # 体重補正
          #ret[:log].push([turn, weight_damage.to_s + "体重補正！"])

          combo_damage = Math.sqrt(combo)
          #ret[:log].push([turn, combo.to_s + "コンボ！！ " + combo_damage.to_s + "倍のダメージ！！"])

          kiai_rand = Tiramon.power_rand(2)
          kiai = (attacker[:temp_sp] + (attacker[:sp] - attacker[:temp_sp]) * kiai_rand * 2.0) / attacker[:max_sp]
          kiai_damage = (1.0 + kiai) / 2.0
          #ret[:log].push([turn, kiai_damage.to_s + "気合補正！"])

          random_damage = 1.0 + Tiramon.dist_rand / 2.0
          #ret[:log].push([turn, random_damage.to_s + "ランダム補正！"])

          if 0 < damage_physical
            damage_magnification = combo_damage * kiai_damage * random_damage
            #ret[:log].push([turn, "合計補正は" + damage_magnification.to_s + "！"])

            if 1 < weight_effect
              ret[:log].push([turn, Tiramon.get_message(Constants::TIRAMON_WEIGHT_DAMAGE, [(weight_effect - 1) * 2.0, 1.0, 0.0].sort.second)])
            end
            #ret[:log].push([turn, combo.to_s + "コンボ！！ " + combo_damage.to_s + "倍のダメージ！！"])
            ret[:log].push([turn, Tiramon.get_message(Constants::TIRAMON_KIAI_DAMAGE, kiai / 2.0)])
            if 1 < random_damage
              ret[:log].push([turn, Tiramon.get_message(Constants::TIRAMON_RANDOM_DAMAGE, (random_damage - 1.0) * 2.0)])
            end
          else
            damage_magnification = 1.0
          end

          defender[:hp] -= damage[:hp] * damage_magnification
          defender[:temp_hp] -= (damage[:thp] + damage[:hp]) * damage_magnification
          defender[:mp] -= damage[:mp] * damage_magnification
          defender[:temp_mp] -= (damage[:tmp] +  damage[:mp]) * damage_magnification
          defender[:sp] -= damage[:sp] * damage_magnification
          defender[:temp_sp] -= (damage[:tsp] + damage[:sp]) * damage_magnification

          total_damage = (damage[:hp] + damage[:thp]) * damage_magnification
          damage_ratio = total_damage / defender[:max_hp]

          if 0.5 < damage_ratio
            # カットイン演出
            if move_data[:element] == 0
              ret[:log].push([3, "/images/tiramon/da.png"])
            elsif move_data[:element] == 1
              ret[:log].push([3, "/images/tiramon/nage.png"])
            elsif move_data[:element] == 2
              ret[:log].push([3, "/images/tiramon/kime.png"])
            end
          end

          #ret[:log].push([turn, (total_damage / defender[:max_hp] * 100).to_i.to_s + "%のダメージを与えた！"])
          ret[:log].push([-turn, Tiramon.get_message(Constants::TIRAMON_DAMAGE, (damage_ratio))])

          # 自爆ダメージ
          self_damage = move_data[:self_damage]
          attacker[:hp] -= self_damage[:hp] * kiai_damage
          attacker[:temp_hp] -= (self_damage[:thp] + self_damage[:hp]) * kiai_damage
          attacker[:mp] -= self_damage[:mp] * kiai_damage
          attacker[:temp_mp] -= (self_damage[:tmp] + self_damage[:mp]) * kiai_damage
          attacker[:sp] -= (self_damage[:sp]) * kiai_damage
          attacker[:temp_sp] -= (self_damage[:tsp] + self_damage[:sp]) * kiai_damage
        end
      else

        ret[:log].push([turn, attacker[:name] + Tiramon.get_message(Constants::TIRAMON_TIERD, rand())])

      end

      [defender, attacker].each{ |t|
        # MPがマイナスになるとバグるため
        t[:temp_mp] = [0, t[:temp_mp], t[:mp]].sort.second

        # 肉体的ダメージが限界の場合、精神に影響する
        mp_damage_by_hp = 0
        if t[:temp_hp] < 0
          mp_damage_by_hp = -t[:temp_hp] / 5

          t[:temp_mp] -= mp_damage_by_hp * 2
          t[:mp] -= mp_damage_by_hp
        end

        t[:hp] = [t[:max_hp] / 8, [t[:hp], t[:max_hp]].min, t[:max_hp]].sort.second
        t[:mp] = [t[:max_mp] / 16, [t[:mp], t[:max_mp]].min, t[:max_mp]].sort.second
        t[:sp] = [t[:max_sp] / 4, [t[:sp], t[:max_sp]].min, t[:max_sp]].sort.second

        # BMIが異常なほどスタミナ回復が遅い
        bmi_damage = [((22.0 - t[:bmi]).abs / 18.0) * 0.5, -0.5, 0.0].sort.second

        t[:temp_hp] += (t[:hp] / t[:max_hp]) * t[:recovery_hp] * Constants::TIRAMON_RECOVER_RATIO[0]
        t[:temp_mp] += (t[:mp] / t[:max_mp]) * t[:recovery_mp] * Constants::TIRAMON_RECOVER_RATIO[1]
        t[:temp_sp] += (t[:sp] / t[:max_sp]) * t[:recovery_sp] * Constants::TIRAMON_RECOVER_RATIO[2] * (1 - bmi_damage)

        # 肉体ダメージ由来の大きな精神ダメージを受けた場合、KOになる可能性がある
        if t[:temp_mp] < 0
          ko_chance = (mp_damage_by_hp / t[:mp])
          t[:ko] = rand() < ko_chance
        end

        t[:temp_hp] = [0, [t[:temp_hp], t[:hp]].min].max
        t[:temp_mp] = [0, [t[:temp_mp], t[:mp]].min].max
        t[:temp_sp] = [t[:temp_sp], t[:sp]].min

      }

      # 攻撃側が自分の攻撃で負けないようにする
      attacker[:ko] = false

      if defender[:ko]
        ret[:log].push([-turn, defender[:name] + Tiramon.get_message(Constants::TIRAMON_GIVE_UP, rand())])
      elsif defender[:temp_mp] == 0
        ret[:log].push([-turn, defender[:name] + Tiramon.get_message(Constants::TIRAMON_GUTS, rand())])
      end

    end

    ret[:log].push([2, [t_1.clone, t_2.clone]])
    ret[:log].push([0, "試合終了！"])

    ret[:time] = time_count
    if t_2[:ko]
      ret[:result] = 1
      ret[:log].push([0, Time.at(time_count).utc.strftime("%M分%S秒") + "、" + last_move + "で" + t_1[:name] + "の勝利！！"])
    elsif t_1[:ko]
      ret[:result] = -1
      ret[:log].push([0, Time.at(time_count).utc.strftime("%M分%S秒") + "、" + last_move + "で" + t_2[:name] + "の勝利！！"])
    else
      ret[:result] = 0
      ret[:log].push([0, "引き分け！！"])
    end

    return ret
  end

  def training?(trainer, training_id)
    if self.tiramon_trainer_id == trainer.id
      if self.can_act?
        d = getData()
        t = ""

        now_level = Tiramon.getLevel(d)

        tiramon_level_efficiency = (1.0 - (now_level / 100.0))
        trainer_level_efficiency = (1.0 + (trainer.level.to_f / 100.0))
        random_efficiency = (1.0 + Tiramon.dist_rand(2) / 2.0)
        efficiency = tiramon_level_efficiency * trainer_level_efficiency * random_efficiency

        case training_id
        when 0 then
          v = d[:weight]
          p = d[:physique]

          e = [(d[:height] ** 2 * 30) * p - v, 0.0].max * 0.10 * random_efficiency
          d[:weight] += e
          amount = e.abs

          t = {name: "増量", effect: "体重 +" + amount.floor(2).to_s }
        when 1 then
          v = d[:weight]
          p = d[:physique]

          e = [(d[:height] ** 2 * 20) * p - v, 0.0].min * 0.10 * random_efficiency
          d[:weight] += e
          amount = e.abs

          t = {name: "減量", effect: "体重 -" + amount.floor(2).to_s }
        when 10 then
          v = d[:train][:abilities][:vital][0]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:abilities][:vital][0] += e
          amount = d[:abilities][:vital][0] * e

          t = {name: "体力トレーニング", effect: "体力 +" + amount.floor(2).to_s }
        when 11 then
          v = d[:train][:abilities][:vital][1]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:abilities][:vital][1] += e
          amount = d[:abilities][:vital][1] * e

          t = {name: "精神力トレーニング", effect: "精神力 +" + amount.floor(2).to_s }
        when 12 then
          v = d[:train][:abilities][:vital][2]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:abilities][:vital][2] += e
          amount = d[:abilities][:vital][2] * e

          t = {name: "スタミナトレーニング", effect: "スタミナ +" + amount.floor(2).to_s }
        when 13 then
          v = d[:train][:abilities][:speed]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:abilities][:speed] += e
          amount = d[:abilities][:speed] * e

          t = {name: "スピードトレーニング", effect: "スピード +" + amount.floor(2).to_s }

        when 14 then
          v = d[:train][:abilities][:speed]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:abilities][:intuition] += e
          amount = d[:abilities][:intuition] * e

          t = {name: "直感トレーニング", effect: "勘が鋭くなった気がする…" }

        when 20 then
          v = d[:train][:abilities][:recovery][0]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:abilities][:recovery][0] += e
          amount = d[:abilities][:recovery][0] * e

          t = {name: "体力回復トレーニング", effect: "体力回復 +" + amount.floor(2).to_s }
        when 21 then
          v = d[:train][:abilities][:recovery][1]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:abilities][:recovery][1] += e
          amount = d[:abilities][:recovery][1] * e

          t = {name: "精神回復トレーニング", effect: "精神回復 +" + amount.floor(2).to_s }
        when 22 then
          v = d[:train][:abilities][:recovery][2]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:abilities][:recovery][2] += e
          amount = d[:abilities][:recovery][2] * e

          t = {name: "スタミナ回復トレーニング", effect: "スタミナ回復 +" + amount.floor(2).to_s }
        when 30 then
          v = d[:train][:skills][:attack][0]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:skills][:attack][0] += e
          amount = d[:skills][:attack][0] * e

          t = {name: "攻撃-打トレーニング", effect: "攻撃-打 +" + (amount * 100).floor(2).to_s }
        when 31 then
          v = d[:train][:skills][:attack][1]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:skills][:attack][1] += e
          amount = d[:skills][:attack][1] * e

          t = {name: "攻撃-投トレーニング", effect: "攻撃-投 +" + (amount * 100).floor(2).to_s }
        when 32 then
          v = d[:train][:skills][:attack][2]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:skills][:attack][2] += e
          amount = d[:skills][:attack][2] * e

          t = {name: "攻撃-極トレーニング", effect: "攻撃-極 +" + (amount * 100).floor(2).to_s }
        when 40 then
          v = d[:train][:skills][:defense][0]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:skills][:defense][0] += e
          amount = d[:skills][:defense][0] * e

          t = {name: "防御-打トレーニング", effect: "防御-打 +" + (amount * 100).floor(2).to_s }
        when 41 then
          v = d[:train][:skills][:defense][1]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:skills][:defense][1] += e
          amount = d[:skills][:defense][1] * e

          t = {name: "防御-投トレーニング", effect: "防御-投 +" + (amount * 100).floor(2).to_s }
        when 42 then
          v = d[:train][:skills][:defense][2]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:skills][:defense][2] += e
          amount = d[:skills][:defense][2] * e

          t = {name: "防御-極トレーニング", effect: "防御-極 +" + (amount * 100).floor(2).to_s }
        else
        end

        d[:bmi] = d[:weight] / (d[:height] ** 2)

        level = Tiramon.getLevel(d)
        d[:train][:level] = level

        if now_level.to_i != level.to_i
          t[:level_up] = "Lvが " + (level.to_i - now_level.to_i).to_s + " あがった！"
        end

        self.data = d.to_json
        self.training_text = t.to_json
        self.save!

        set_act
        return true
      end
    end
    return false
  end

  def set_style?(trainer, style)
    if self.tiramon_trainer_id == trainer.id
      d = getData()

      d[:style][:tactics][:intuition] = style[:intuition]
      d[:style][:tactics][:study] = style[:study]
      d[:style][:tactics][:flexible] = style[:flexible]
      d[:style][:tactics][:wary] = style[:wary]

      self.data = d.to_json
      self.save!
      return true
    end
    return false
  end

  def set_wary?(trainer, wary)
    if self.tiramon_trainer_id == trainer.id
      d = getData()

      d[:style][:wary] = wary

      self.data = d.to_json
      self.save!
      return true
    end
    return false
  end

  def set_move?(trainer, moves)
    if self.tiramon_trainer_id == trainer.id
      d = getData()

      d[:moves] = moves

      # 簡易チェック
      4.times do |i|
        4.times do |j|
          if d[:moves][i][j][5] == nil
            return false
          end
        end
      end

      # 覚えてない技を使えないようにする
      allmove = d[:moves].flatten.uniq.sort
      available_moves = self.getMove
      error_move = allmove.difference(available_moves)
      if 0 < error_move.size
        return false
      end

      self.data = d.to_json
      self.save!
      return true
    end
    return false
  end

  def get_move?(trainer, move)
    if self.tiramon_trainer_id == trainer.id
      if self.can_act?
        m = self.getMove()

        # リストにない技を覚えられないようにする
        getable_moves = self.getGetMove
        if !getable_moves.include?(move)
          return false
        end

        # すでに覚えている技を覚えられないようにする
        already_moves = self.getMove
        if already_moves.include?(move)
          return false
        end

        m << move
        getable_moves.delete(move)

        move_list = TiramonMove.first.getData
        move_data = TiramonMove.getMoveData(move_list.find{|o| o[:id] == move})
        t = {name: "新技習得", effect: move_data[:name] + "を習得した" }

        self.move = m.to_json
        self.get_move = getable_moves.to_json
        self.training_text = t.to_json
        self.save!

        set_act
        return true
      end
    end
    return false
  end

  def inspire_move?(trainer)
    if self.tiramon_trainer_id == trainer.id
      if self.can_act?

        move_list = TiramonMove.first.getData

        r = rand(3..6)
        t = {name: "技をひらめく", effect: r.to_s + "個の技をひらめいた" }

        self.get_move = move_list.pluck(:id).difference(self.getMove).sample(r).sort
        self.training_text = t.to_json
        self.save!

        set_act
        return true
      end
    end
    return false
  end

  def refresh?(trainer, level = 0)
    if self.tiramon_trainer_id == trainer.id
      refresh_time = Constants::TIRAMON_REFRESH_TERM[level]

        if trainer.user.sub_points?(Constants::TIRAMON_REFRESH_PRICE[level])
          update(act: self.act - refresh_time)
          return true
        end
    end
    return false
  end

  def rename?(trainer, name)
    if self.tiramon_trainer_id == trainer.id
      if !self.adjust?
        if trainer.user.sub_points?(Constants::TIRAMON_RENAME_PRICE)

          d = getData()

          old_name = d[:name]
          d[:name] = name

          # 簡易チェック
          if !(1..12).cover?(name.length)
            return false
          end

          self.data = d.to_json
          self.save!

          return true
        end
      end
    end
    return false
  end

  def set_entry?(trainer, entry)
    if self.tiramon_trainer_id == trainer.id
      if !self.adjust?
        if trainer.user.sub_points?(Constants::TIRAMON_CLASS_CHANGE_PRICE)

          self.entry = entry

          if !entry
            self.rank = 6
          end

          self.save!

          return true
        end
      end
    end
    return false
  end

  def release?(trainer)
    if self.tiramon_trainer_id == trainer.id
      if !self.adjust?

        update(tiramon_trainer_id: nil)
        return true
      end
    end
    return false
  end

  def get_level()
    d = self.getData()
    return d[:train][:level]
  end

  def adventure_battle(trainer, enemy_id)
    if self.tiramon_trainer_id == trainer.id
      if self.can_adventure?

        adventure_data = self.getAdventureData
        adventure_data_level = adventure_data[:level].nil? ? {} : adventure_data[:level]
        adventure_data_stage = adventure_data[:stage].nil? ? {} : adventure_data[:stage]
        adventure_data_enemy = adventure_data[:enemy].nil? ? {} : adventure_data[:enemy]

        user = trainer.user

        enemy = TiramonEnemy.find_by(id: enemy_id)
        result = Tiramon.battle(self.getData, enemy.getData)

        # 挑戦権がない場合は終了
        if 1 <= enemy.stage
          if adventure_data_stage[:"#{enemy.stage - 1}"] != true
            return nil
          end
        end

        # クリア判定
        if result.present?
          if result[:result] == 1
            # 初勝利の場合
            if adventure_data_enemy[:"#{enemy_id}"] != true
              adventure_data_enemy[:"#{enemy_id}"] = true

              user.add_points(Constants::TIRAMON_ADVENTURE_PRIZE[enemy.stage])
            end
          else
            self.update(adventure_time: Time.current + Constants::TIRAMON_ADVENTURE_FAIL_TIME[enemy.stage])
          end

          # ステージクリア判定
          enemies = TiramonEnemy.where(enemy_class: enemy.enemy_class).where(stage: enemy.stage)
          stage_clear_flag = true
          enemies.map do |e|
            if adventure_data_enemy[:"#{e.id}"] != true
              stage_clear_flag = false
              break
            end
          end

          if stage_clear_flag
            adventure_data_stage[:"#{enemy.stage}"] = true
          end

          # レベルクリア判定
          stages = TiramonEnemy.where(enemy_class: enemy.enemy_class).group(:stage).select(:stage)
          level_clear_flag = true
          stages.map do |s|
            if adventure_data_stage[:"#{s.stage}"] != true
              level_clear_flag = false
              break
            end
          end

          if level_clear_flag
            adventure_data_level[:"#{enemy.enemy_class}"] = true
          end

          adventure_data[:level] = adventure_data_level
          adventure_data[:stage] = adventure_data_stage
          adventure_data[:enemy] = adventure_data_enemy
          self.update(adventure_data: adventure_data.to_json)

          return result
        end

      end
    end
    return nil
  end

  def if_bonus?()
    return (!bonus_time.nil? and Time.current < bonus_time)
  end

  def can_act?()
    can_act = false

    if self.act.nil?
      can_act = true
    else
      if self.if_bonus?
        can_act = self.act < Time.current - Constants::TIRAMON_TRAINING_BONUS_TERM
      else
        can_act = self.act < Time.current - Constants::TIRAMON_TRAINING_TERM
      end
    end

    return (can_act and !adjust?)
  end

  def act_next
    diff = 0

    if self.act.nil?
      diff = 0
    else
      if self.if_bonus?
        diff = self.act - (Time.current - Constants::TIRAMON_TRAINING_BONUS_TERM)
      else
        diff = self.act - (Time.current - Constants::TIRAMON_TRAINING_TERM)
      end
    end
    diff = [diff, 0].max

    return diff
  end

  def act_gauge
    g = 0.0

    if self.act.nil?
      g = 1.0
    else
      g = (Time.current - self.act) / Constants::TIRAMON_TRAINING_TERM_MAX
    end
    g = [g, 0.0, 1.0].sort.second

    return g
  end

  # 試合が組まれたら調整のため育成できなくなる
  def adjust?()
    battle_red = TiramonBattle.where(red_tiramon_id: self.id).where("datetime > ?", Time.current).count
    battle_blue = TiramonBattle.where(blue_tiramon_id: self.id).where("datetime > ?", Time.current).count
    battle = battle_red + battle_blue
    return 0 < battle
  end

  def can_adventure?()
    return (adventure_time.nil? or adventure_time < Time.current)
  end

  def set_act
    if self.act.nil?
      self.act = Time.current - Constants::TIRAMON_TRAINING_TERM_MAX
    end

    if self.act < Time.current - Constants::TIRAMON_TRAINING_TERM_MAX
      self.act = Time.current - Constants::TIRAMON_TRAINING_TERM_MAX
    end

    if if_bonus?
      update(act: self.act + Constants::TIRAMON_TRAINING_BONUS_TERM)
    else
      update(act: self.act + Constants::TIRAMON_TRAINING_TERM)
    end
  end

  # 試合を完了する
  def self.complete_battles
    while true do
      battle = TiramonBattle.where(result: nil).where("datetime < ?", Time.current).order(datetime: :asc).first
      if battle.present?
        battle.set_result
      else
        break
      end
    end
  end

  def self.get_moves(t = {})
    return t[:moves].flatten.uniq.sort
  end

  def self.get_pride(t = {})
    v = Constants::TIRAMON_MOVE_VALUE
    return [t[:hp] * v[0], t[:temp_hp] * v[1], t[:mp] * v[2], t[:temp_mp] * v[3], t[:sp] * v[4], [t[:temp_sp] * v[5], 0.0].max].sum.to_f
  end

  def self.get_risk(d = {})
    v = Constants::TIRAMON_MOVE_VALUE
    return [d[:hp] * v[0], d[:thp] * v[1], d[:mp] * v[2], d[:tmp] * v[3], d[:sp] * v[4], d[:tsp] * v[5]].sum
  end

  def self.get_message(a = [], n = 0.0)
    r = a[[(a.length.to_f * n).to_i, a.length - 1, 0].sort.second]

    if r.instance_of?(Array)
      return r.flatten.sample
    else
      return r
    end
  end

  def self.dist_rand(n = 1)
    a = []
    r = Random.new
    n.times do
      a.push(r.rand() - r.rand())
    end
    return a.sum / a.length
  end

  # マイナスに振れたら値が半分になるdist_rand（身長、BMI用）
  def self.dist_rand_2(n = 1)
    a = []
    r = Random.new
    n.times do
      a.push(r.rand() - r.rand())
    end
    ret = a.sum / a.length
    return ret < 0 ? ret / 2 : ret
  end

  def self.power_rand(n = 1)
    a = []
    r = Random.new
    n.times do
      a.push(r.rand())
    end
    return a.inject(:*)
  end

  def self.set_miss()
    tiramons = Tiramon.where.not(rank: 6).where.not(tiramon_trainer: nil)

    tiramons.each do |tiramon|
      if tiramon.act < 7.days.ago
        tiramon.entry = false
        tiramon.rank = 6
        tiramon.save!
      end
    end
  end

  def self.leave()
    tiramons = Tiramon.where(tiramon_trainer: nil)
    tiramons.destroy_all
  end

  def self.leap(min, max, f)
    diff = max.to_f - min.to_f
    return [(f - min.to_f) / diff, 0.0, 1.0].sort.second
  end
end
