class Tiramon < ApplicationRecord
  belongs_to :tiramon_trainer, optional: true

  def self.generate(trainer = TiramonTrainer.none, min_level = 1, max_level = 10)
    tiramon = Tiramon.new
    tiramon.data = Tiramon.generateData(min_level, max_level).to_json

    move_list = TiramonMove.first.getData
    tiramon.move = Tiramon.get_moves(tiramon.getData)
    tiramon.get_move = move_list.pluck(:id).sample(rand(0..5)).sort.difference(Tiramon.get_moves(tiramon.getData))

    tiramon.experience = 0
    tiramon.act = Time.current
    tiramon.get_limit = 30.minute.since
    tiramon.right = trainer.id

    tiramon.save!
    return tiramon
  end

  def get?(trainer = TiramonTrainer.none)
    if right == trainer.id and Time.current < get_limit
      if trainer.use_ball?
        update(right: nil, tiramon_trainer_id: trainer.id)
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def self.generateData(min_level, max_level)
    min_power = min_level / 100.0
    max_power = max_level / 100.0
    data = {
      name: Gimei.male.kanji,
      height: 1.81,
      weight: 101,
      bmi: 25,
      abilities: {
        vital: [100, 100, 100],
        recovery: [100, 100, 100],
        speed: 100,
        intuition: 0.0,
      },
      skills: {
        attack: [1.0, 1.0, 1.0],
        defense: [1.0, 1.0, 1.0],
      },
      style: {
        tactics: {
          intuition: 0,
          study: 100,
          flexible: 100,
          wary: 100,
        },
        wary: [100, 100, 100],
      },
      train: {
        level: 0.0,
        abilities: {
          vital: [1.0, 1.0, 1.0],
          recovery: [1.0, 1.0, 1.0],
          speed: 1.0,
          intuition: 1.0,
        },
        skills: {
          attack: [1.0, 1.0, 1.0],
          defense: [1.0, 1.0, 1.0],
        },
      },
      moves: [
        [
          ["102001", "103001", "201001", "301006", "305006", "302004"],
          ["000001", "103001", "201001", "203001", "301006", "305007"],
          ["103003", "106027", "203001", "205001", "301006", "305007"],
          ["103003", "106027", "203001", "205011", "305007", "305001"],
        ],
        [
          ["102001", "103001", "201001", "301006", "305006", "302004"],
          ["000001", "103001", "201001", "203001", "301006", "305007"],
          ["103003", "106027", "203001", "205001", "301006", "305007"],
          ["103003", "106027", "203001", "205011", "305007", "305001"],
        ],
        [
          ["102001", "103001", "201001", "301006", "305006", "302004"],
          ["000001", "103001", "201001", "203001", "301006", "305007"],
          ["103003", "106027", "203001", "205001", "301006", "305007"],
          ["103003", "106027", "203001", "205011", "305007", "305001"],
        ],
        [
          ["102001", "103001", "201001", "301006", "305006", "302004"],
          ["000001", "103001", "201001", "203001", "301006", "305007"],
          ["103003", "106027", "203001", "205001", "301006", "305007"],
          ["103003", "106027", "203001", "205011", "305007", "305001"],
        ],
      ]
    }

    data[:bmi] = (28.0 + 6.0 * Tiramon.dist_rand(2))
    data[:height] = 1.75 + (0.25 * Tiramon.dist_rand(2))
    data[:weight] = data[:height] ** 2 * data[:bmi]

    data[:abilities][:vital] = [100 + 50 * Tiramon.dist_rand(2), 100 + 50 * Tiramon.dist_rand(2), 100 + 50 * Tiramon.dist_rand(2)]
    data[:abilities][:recovery] = [100 + 50 * Tiramon.dist_rand(2), 100 + 50 * Tiramon.dist_rand(2), 100 + 50 * Tiramon.dist_rand(2)]
    data[:abilities][:speed] = 100 + 50 * Tiramon.dist_rand(2)
    data[:abilities][:intuition] = Tiramon.power_rand(4)
    data[:skills][:attack] = [1 + 0.5 * Tiramon.dist_rand(1), 1 + 0.5 * Tiramon.dist_rand(1), 1 + 0.5 * Tiramon.dist_rand(1)]
    data[:skills][:defense] = [1 + 0.5 * Tiramon.dist_rand(1), 1 + 0.5 * Tiramon.dist_rand(1), 1 + 0.5 * Tiramon.dist_rand(1)]

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

    def getData
      return eval(data)
    end

    def getMove
      return eval(move)
    end

    def getGetMove
      return eval(get_move)
    end

  def getTrainingText
    if training_text.present?
      return eval(training_text)
    else
      return nil
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
    t[:bmi] = t[:weight] / (t[:height] ** 2)
    t[:attack] = [d[:skills][:attack][0] * d[:train][:skills][:attack][0], d[:skills][:attack][1] * d[:train][:skills][:attack][1], d[:skills][:attack][2] * d[:train][:skills][:attack][2]]
    t[:defense] = [d[:skills][:defense][0] * d[:train][:skills][:defense][0], d[:skills][:defense][1] * d[:train][:skills][:defense][1], d[:skills][:defense][2] * d[:train][:skills][:defense][2]]

    return t
  end

  def self.about(n = 0, a = 1)
    return (n / a).round * a
  end

  def self.battle(tiramon_1 = Card.none, tiramon_2 = Card.none)
    require "matrix"

    move_list = TiramonMove.first.getData

    ret = {"result": 0, "log": []}

    if tiramon_1.blank? or tiramon_2.blank?
      ret[:result] = 0
      ret[:log].push([0, "試合不成立！"])
    end

    ret[:log].push([0, "選手入場！！！"])

    t_1 = Tiramon.getBattleData(tiramon_1.getData)
    t_2 = Tiramon.getBattleData(tiramon_2.getData)

    ret[:log].push([-1, "赤コーナー！"])
    ret[:log].push([-1, (t_2[:height] * 100).to_i.to_s + "センチ " + (t_2[:weight]).to_i.to_s + "kg！"])
    ret[:log].push([-1, t_2[:name] + "！！！"])
    ret[:log].push([0, "歓声が上がる！！！"])

    ret[:log].push([1, "青コーナー！"])
    ret[:log].push([1, (t_1[:height] * 100).to_i.to_s + "センチ " + (t_1[:weight]).to_i.to_s + "kg！"])
    ret[:log].push([1, t_1[:name] + "！！！"])
    ret[:log].push([0, "歓声が上がる！！！"])

    # 勝負は試合の前から始まっている…
    t_1[:study] = (Vector.elements(t_2[:attack]).normalize).to_a
    t_2[:study] = (Vector.elements(t_1[:attack]).normalize).to_a

    ret[:log].push([0, "…"])
    ret[:log].push([0, "60分1本勝負！"])
    ret[:log].push([0, t_1[:name] + " 対 " + t_2[:name] + "！"])
    ret[:log].push([0,  "試合開始！"])
    ret[:log].push([0,  "ゴングが鳴った！！！"])
    # ret[:log].push([2, [t_1.clone, t_2.clone]])

    draw = false
    turn_count = 0
    time_count = 0.second
    last_move = ""
    while !t_1[:ko] and !t_2[:ko] and !draw

      turn_count += 1
      turn = 0

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

      t_1_pride = Tiramon.get_pride(t_1)
      t_2_pride = Tiramon.get_pride(t_2)

      t_1_motivation = [t_2_pride / t_1_pride, 2.0, 0.5].sort.second
      t_2_motivation = [t_1_pride / t_2_pride, 2.0, 0.5].sort.second

      #ret[:log].push([1, t_1_motivation])
      #ret[:log].push([-1, t_2_motivation])

      ret[:log].push([1, Tiramon.get_message(Constants::TIRAMON_MOTIVATION, t_1_motivation / 2)])
      ret[:log].push([-1, Tiramon.get_message(Constants::TIRAMON_MOTIVATION, t_2_motivation / 2)])


      t_1_move_power = [t_1[:speed] * t_1_move_power_sp * t_1_weight_balance * t_1_motivation, 0.0].max
      t_2_move_power = [t_2[:speed] * t_2_move_power_sp * t_2_weight_balance * t_2_motivation, 0.0].max

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

        ret[:log].push([turn, Tiramon.get_message(Constants::TIRAMON_DOUBLE_DOWN, rand())])

        # お互い寝っ転がりっぱなしはしょっぱいのでスタミナ回復
        t_1_recovery_power = (t_1[:sp] / t_1[:max_sp]) * t_1[:recovery_sp]
        t_2_recovery_power = (t_2[:sp] / t_2[:max_sp]) * t_2[:recovery_sp]

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
        moves = attacker[:moves][attacker_hp][defender_hp]
        move = moves.sample

        move_data = TiramonMove.getMoveData(move_list.find{|m| m[:id] == move})
        last_move = move_data[:name]

        #ret[:log].push([turn, move_data[:name] + "を狙っている！"])

        damage = {hp: 0.0, thp: 0.0, mp: 0.0, tmp: 0.0, sp: 0.0, tsp: 0.0}

        3.times { |element|
        	damage[:hp] += move_data[:damage][:hp][element].to_f * (attacker[:attack][element].to_f / defender[:defense][element].to_f)
        	damage[:thp] += move_data[:damage][:thp][element].to_f * (attacker[:attack][element].to_f / defender[:defense][element].to_f)
        	damage[:mp] += move_data[:damage][:mp][element].to_f * (attacker[:attack][element].to_f / defender[:defense][element].to_f)
        	damage[:tmp] += move_data[:damage][:tmp][element].to_f * (attacker[:attack][element].to_f / defender[:defense][element].to_f)
        	damage[:sp] += move_data[:damage][:sp][element].to_f * (attacker[:attack][element].to_f / defender[:defense][element].to_f)
        	damage[:tsp] += move_data[:damage][:tsp][element].to_f * (attacker[:attack][element].to_f / defender[:defense][element].to_f)
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

          ret[:log].push([turn, Tiramon.get_message(Constants::TIRAMON_FAIL_ATTACK, rand())])

          # SP消費
          attacker[:temp_sp] -= attacker[:temp_sp] / 2
          # SP回復
          defender[:temp_sp] += (defender[:sp] - [defender[:temp_sp], 0.0].max) / 2

        else

          ret[:log].push([turn, move_data[:name] + Tiramon.get_message(Constants::TIRAMON_SUCCESS_ATTACK, rand())])

          # ダメージを与える
          # 体重補正
          weight_damage = attacker[:weight] / defender[:weight]
          #ret[:log].push([turn, weight_damage.to_s + "体重補正！"])

          kiai_rand = Tiramon.power_rand(2)
          kiai = (attacker[:temp_sp] + (attacker[:sp] - attacker[:temp_sp]) * kiai_rand * 2) / attacker[:max_sp]
          kiai_damage = (1.0 + kiai) / 2.0
          #ret[:log].push([turn, kiai_damage.to_s + "気合補正！"])

          bmi_damage = 0.5 + ((22.0 - attacker[:bmi]).abs / 9.0)
          #ret[:log].push([turn, bmi_damage.to_s + "BMI補正！"])

          random_damage = 1.0 + (rand()-rand()) / 2.0
          #ret[:log].push([turn, random_damage.to_s + "ランダム補正！"])

          if 0 < damage_physical

            damage_magnification = weight_damage * kiai_damage * random_damage
            #ret[:log].push([turn, "合計補正は" + damage_magnification.to_s + "！"])

            if 1 < weight_damage
              ret[:log].push([turn, Tiramon.get_message(Constants::TIRAMON_WEIGHT_DAMAGE, [(weight_damage - 1) * 2.0, 1.0, 0.0].sort.second)])
            end
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

          total_damage = damage.values.inject(:+) * damage_magnification
          damage_ratio = total_damage / defender[:max_hp]

          if 1.0 < damage_ratio
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
          ret[:log].push([-turn, Tiramon.get_message(Constants::TIRAMON_DAMAGE, (damage_ratio) / 2)])

          # 自爆ダメージ

          self_damage = move_data[:self_damage]
          attacker[:hp] -= self_damage[:hp]
          attacker[:temp_hp] -= self_damage[:thp] + self_damage[:hp]
          attacker[:mp] -= self_damage[:mp] * kiai_damage
          attacker[:temp_mp] -= self_damage[:tmp] + self_damage[:mp] * kiai_damage
          attacker[:sp] -= (self_damage[:sp]) * kiai_damage * bmi_damage
          attacker[:temp_sp] -= (self_damage[:tsp] + self_damage[:sp]) * kiai_damage * bmi_damage
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

        t[:temp_hp] += (t[:hp] / t[:max_hp]) * t[:recovery_hp] * Constants::TIRAMON_RECOVER_RATIO[0]
        t[:temp_mp] += (t[:mp] / t[:max_mp]) * t[:recovery_mp] * Constants::TIRAMON_RECOVER_RATIO[1]
        t[:temp_sp] += (t[:sp] / t[:max_sp]) * t[:recovery_sp] * Constants::TIRAMON_RECOVER_RATIO[2]

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

      # 時間経過
      time_count += 30.second
      if 60.minute < time_count
        draw = true
      end
    end

    ret[:log].push([2, [t_1.clone, t_2.clone]])
    ret[:log].push([0, "試合終了！"])

    if draw
      ret[:result] = 0
      ret[:log].push([0, "引き分け！！"])
    elsif t_2[:ko]
      ret[:result] = 1
      ret[:log].push([0, Time.at(time_count).utc.strftime("%M分%S秒") + "、" + last_move + "で" + t_1[:name] + "の勝利！！"])
    elsif t_1[:ko]
      ret[:result] = -1
      ret[:log].push([0, Time.at(time_count).utc.strftime("%M分%S秒") + "、" + last_move + "で" + t_2[:name] + "の勝利！！"])
    else
      ret[:result] = 0
      ret[:log].push([0, "試合は闇に葬られた…"])
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
          e = [(d[:height] ** 2 * 40) - v, 0.0].max * 0.10 * random_efficiency
          d[:weight] += e
          amount = e.abs

          t = {name: "増量", effect: "体重 +" + amount.floor(2).to_s }
        when 1 then
          v = d[:weight]
          e = [(d[:height] ** 2 * 20) - v, 0.0].min * 0.10 * random_efficiency
          d[:weight] += e
          amount = e.abs

          t = {name: "減量", effect: "体重 -" + amount.floor(2).to_s }
        when 10 then
          v = d[:train][:abilities][:vital][0]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:abilities][:vital][0] += e
          amount = d[:abilities][:vital][0] * e

          t = {name: "体力トレーニング", effect: "基礎能力-体力 +" + amount.floor(2).to_s }
        when 11 then
          v = d[:train][:abilities][:vital][1]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:abilities][:vital][1] += e
          amount = d[:abilities][:vital][1] * e

          t = {name: "メンタルトレーニング", effect: "基礎能力-精神力 +" + amount.floor(2).to_s }
        when 12 then
          v = d[:train][:abilities][:vital][2]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:abilities][:vital][2] += e
          amount = d[:abilities][:vital][2] * e

          t = {name: "スタミナトレーニング", effect: "基礎能力-スタミナ +" + amount.floor(2).to_s }
        when 13 then
          v = d[:train][:abilities][:speed]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:abilities][:speed] += e
          amount = d[:abilities][:speed] * e

          t = {name: "スピードトレーニング", effect: "基礎能力-スピード +" + amount.floor(2).to_s }

        when 20 then
          v = d[:train][:abilities][:recovery][0]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:abilities][:recovery][0] += e
          amount = d[:abilities][:recovery][0] * e

          t = {name: "体力トレーニング", effect: "回復力-体力 +" + amount.floor(2).to_s }
        when 21 then
          v = d[:train][:abilities][:recovery][1]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:abilities][:recovery][1] += e
          amount = d[:abilities][:recovery][1] * e

          t = {name: "メンタルトレーニング", effect: "回復力-精神力 +" + amount.floor(2).to_s }
        when 22 then
          v = d[:train][:abilities][:recovery][2]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:abilities][:recovery][2] += e
          amount = d[:abilities][:recovery][2] * e

          t = {name: "スタミナトレーニング", effect: "回復力-スタミナ +" + amount.floor(2).to_s }
        when 30 then
          v = d[:train][:skills][:attack][0]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:skills][:attack][0] += e
          amount = d[:skills][:attack][0] * e

          t = {name: "打撃トレーニング", effect: "技術力-攻撃-打 +" + (amount * 100).floor(2).to_s }
        when 31 then
          v = d[:train][:skills][:attack][1]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:skills][:attack][1] += e
          amount = d[:skills][:attack][1] * e

          t = {name: "レスリングトレーニング", effect: "技術力-攻撃-投 +" + (amount * 100).floor(2).to_s }
        when 32 then
          v = d[:train][:skills][:attack][2]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:skills][:attack][2] += e
          amount = d[:skills][:attack][2] * e

          t = {name: "寝技トレーニング", effect: "技術力-攻撃-極 +" + (amount * 100).floor(2).to_s }
        when 40 then
          v = d[:train][:skills][:defense][0]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:skills][:defense][0] += e
          amount = d[:skills][:defense][0] * e

          t = {name: "打撃スパーリング", effect: "技術力-防御-打 +" + (amount * 100).floor(2).to_s }
        when 41 then
          v = d[:train][:skills][:defense][1]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:skills][:defense][1] += e
          amount = d[:skills][:defense][1] * e

          t = {name: "レスリングスパーリング", effect: "技術力-防御-投 +" + (amount * 100).floor(2).to_s }
        when 42 then
          v = d[:train][:skills][:defense][2]
          e = [2.0 - v, 0.0].max * (1 + Tiramon.dist_rand(2)) * 0.05 * efficiency
          d[:train][:skills][:defense][2] += e
          amount = d[:skills][:defense][2] * e

          t = {name: "寝技スパーリング", effect: "技術力-防御-極 +" + (amount * 100).floor(2).to_s }
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

        update(act: Time.current + Constants::TIRAMON_TRAINING_TERM)
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

        update(act: Time.current + Constants::TIRAMON_TRAINING_TERM)
        return true
      end
    end
    return false
  end

  def inspire_move?(trainer)
    if self.tiramon_trainer_id == trainer.id
      if self.can_act?

        move_list = TiramonMove.first.getData

        r = rand(1..5)
        t = {name: "技をひらめく", effect: r.to_s + "個の技をひらめいた" }

        self.get_move = move_list.pluck(:id).difference(self.getMove).sample(r).sort
        self.training_text = t.to_json
        self.save!

        update(act: Time.current + Constants::TIRAMON_TRAINING_TERM)
        return true
      end
    end
    return false
  end

  def refresh?(trainer)
    if self.tiramon_trainer_id == trainer.id
      if Time.current < act
        if trainer.user.sub_points?(Constants::TIRAMON_REFRESH_PRICE)

        update(act: Time.current)
        return true
        end
      end
    end
    return false
  end

  def rename?(trainer, name)
    if self.tiramon_trainer_id == trainer.id
      if self.can_act?
        d = getData()

        old_name = d[:name]
        d[:name] = name

        # 簡易チェック
        if !(1..12).cover?(name.length)
          return false
        end

        t = {name: "名前変更", effect: old_name + "から変更した" }

        self.data = d.to_json
        self.training_text = t.to_json
        self.save!

        update(act: Time.current + Constants::TIRAMON_TRAINING_TERM)
        return true
      end
    end
    return false
  end

  def set_rank?(trainer, rank)
    if self.tiramon_trainer_id == trainer.id
      if self.can_act?

        t = {name: "階級変更", effect: Constants::TIRAMON_RULE_NAME[self.rank] + "から変更した" }
        self.training_text = t.to_json
        self.save!

        update(rank: rank)
        update(act: Time.current + Constants::TIRAMON_TRAINING_TERM)
        return true
      end
    end
    return false
  end

  def release?(trainer)
    if self.tiramon_trainer_id == trainer.id
      update(tiramon_trainer_id: nil)
      return true
    end
    return false
  end

  def can_act?()
    return ((act.nil? or act < Time.current) and !adjust?)
  end

  # 試合が組まれたら調整のため育成できなくなる
  def adjust?()
    battle_red = TiramonBattle.where(red_tiramon_id: self.id).where("datetime > ?", Time.current).count
    battle_blue = TiramonBattle.where(blue_tiramon_id: self.id).where("datetime > ?", Time.current).count
    battle = battle_red + battle_blue
    return 0 < battle
  end

  # 試合を完了する
  def self.complete_battles
    incomplete_battles = TiramonBattle.where(result: nil).where("datetime < ?", Time.current)
    incomplete_battles.find_each do |battle|
      battle.set_result
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

  def self.power_rand(n = 1)
    a = []
    r = Random.new
    n.times do
      a.push(r.rand())
    end
    return a.inject(:*)
  end

end
