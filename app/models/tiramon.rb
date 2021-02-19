class Tiramon < ApplicationRecord
  belongs_to :user

  def getData
    return eval(data)
  end

  def self.battle(tiramon_1 = Card.none, tiramon_2 = Card.none)
    require "matrix"

    move_list = TiramonMove.first.getData

    ret = {"result": 0, "log": []}

    if tiramon_1.blank? or tiramon_2.blank?
      ret[:result] = 0
      ret[:log].push([0, "試合不成立！"])
    end

    t = tiramon_1
    d = t.getData
    t_1 = {
      name: d[:name],
      max_hp: d[:abilities][0].to_f,
      max_mp: d[:abilities][2].to_f,
      max_sp: d[:abilities][4].to_f,
      recovery_hp: d[:abilities][1].to_f,
      recovery_mp: d[:abilities][3].to_f,
      recovery_sp: d[:abilities][5].to_f,
      hp: d[:abilities][0].to_f,
      mp: d[:abilities][2].to_f,
      sp: d[:abilities][4].to_f,
      temp_hp: d[:abilities][0].to_f,
      temp_mp: d[:abilities][2].to_f,
      temp_sp: d[:abilities][4].to_f,
      speed: d[:abilities][6].to_f,
      attack: d[:attack],
      defense: d[:defense],
      moves: d[:moves],
      wariness: [0, 0, 0],
      ko: false,
    }

    t = tiramon_2
    d = t.getData
    t_2 = {
      name: d[:name],
      max_hp: d[:abilities][0].to_f,
      max_mp: d[:abilities][2].to_f,
      max_sp: d[:abilities][4].to_f,
      recovery_hp: d[:abilities][1].to_f,
      recovery_mp: d[:abilities][3].to_f,
      recovery_sp: d[:abilities][5].to_f,
      hp: d[:abilities][0].to_f,
      mp: d[:abilities][2].to_f,
      sp: d[:abilities][4].to_f,
      temp_hp: d[:abilities][0].to_f,
      temp_mp: d[:abilities][2].to_f,
      temp_sp: d[:abilities][4].to_f,
      speed: d[:abilities][6].to_f,
      attack: d[:attack],
      defense: d[:defense],
      moves: d[:moves],
      wariness: [0, 0, 0],
      ko: false,
    }

    # 勝負は試合の前から始まっている…
    t_1[:wariness] = (Vector.elements(t_2[:attack]) * t_1[:max_hp]).to_a
    t_2[:wariness] = (Vector.elements(t_1[:attack]) * t_2[:max_hp]).to_a

    ret[:log].push([0, t_1[:name] + "対" + t_2[:name] + "の試合開始！"])
    # ret[:log].push([nil, [t_1.clone, t_2.clone]])

    turn_count = 0
    while !t_1[:ko] and !t_2[:ko]

      turn_count += 1
      turn = 0

      t_1_move_power_hp = [t_1[:temp_hp] / t_1[:max_hp], 0.0].max
      t_1_move_power_sp = [t_1[:temp_sp] / t_1[:max_sp], 0.0].max
      t_2_move_power_hp = [t_2[:temp_hp] / t_2[:max_hp], 0.0].max
      t_2_move_power_sp = [t_2[:temp_sp] / t_2[:max_sp], 0.0].max

      t_1_move_power = [t_1[:speed] * t_1_move_power_sp, 0.0].max
      t_2_move_power = [t_2[:speed] * t_2_move_power_sp, 0.0].max

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

      if turn_count % 1 == 0
        ret[:log].push([nil, [t_1.clone, t_2.clone]])
      end

      if turn == 0

        ret[:log].push([0, "お互いに倒れて動けない…！"])
        # SP回復
        attacker[:temp_sp] += attacker[:max_sp] / 10
        defender[:temp_sp] += defender[:max_sp] / 10

      elsif 0 < attacker[:temp_sp]

        ret[:log].push([turn, attacker[:name] + "が動いた！"])

        attacker_hp = [((1 - attacker[:temp_hp] / attacker[:max_hp]) * 4).to_i, 3].min
        defender_hp = [((1 - defender[:temp_hp] / defender[:max_hp]) * 4).to_i, 3].min
        moves = attacker[:moves][attacker_hp][defender_hp]
        move = moves.sample

        move_data = move_list.find{|m| m[:id] == move}

        ret[:log].push([turn, move_data[:name] + "！"])

        damage = [[[0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0]]]

        move_data[:damage].length.times { |layer|
          move_data[:damage][layer].length.times { |type|
            move_data[:damage][layer][type].length.times { |element|
            	damage[layer][type][element] += move_data[:damage][layer][type][element] * attacker[:attack][element].to_f / defender[:defense][element].to_f
            }
          }
        }

        # 警戒心(tempダメージのみを警戒する)
        damage_element = []
        damage_element[0] = damage[0][1][0] + damage[1][1][0] + damage[2][1][0]
        damage_element[1] = damage[0][1][1] + damage[1][1][1] + damage[2][1][1]
        damage_element[2] = damage[0][1][2] + damage[1][1][2] + damage[2][1][2]

        # 警戒心が上昇
        defender[:wariness][0] += damage_element[0]
        defender[:wariness][1] += damage_element[1]
        defender[:wariness][2] += damage_element[2]

        # 命中率の計算
        wariness = 0
        damage_vector = Vector.elements(damage_element)
        if !damage_vector.zero?
          damage_vector = damage_vector.normalize
        end
        ret[:log].push([turn, "属性は" + damage_vector.to_s ])

        wariness_vector = Vector.elements(defender[:wariness])
        if !wariness_vector.zero?
          wariness_vector = wariness_vector.normalize
        end
        ret[:log].push([-turn, "警戒は" + wariness_vector.to_s ])

        wariness = damage_vector.dot(wariness_vector)

        avoid_hp = (1 + [defender[:temp_hp] / defender[:max_hp], 0.0].max) / 2
        avoid_sp = (1 + [defender[:temp_sp] / defender[:max_sp], 0.0].max) / 2

        ret[:log].push([turn, "命中率" + ((1 - wariness * avoid_hp) * 100).to_i.to_s + "%" ])

        if rand() < wariness * avoid_hp * avoid_sp

          ret[:log].push([-turn, "攻撃を読んでいた！"])

          # SP消費
          attacker[:temp_sp] -= attacker[:temp_sp] / 2
          # SP回復
          defender[:temp_sp] += (defender[:max_sp] - defender[:temp_sp]) / 2

        else

          # ダメージを与える
          sp_damage = (1 + [attacker[:temp_sp] / attacker[:max_sp], 0.0].max) / 2
          random_damage = 1 + (rand()-rand()) / 2
          ret[:log].push([turn, sp_damage.to_s + " * " + random_damage.to_s + "ダメージ補正！"])
          defender[:hp] -= damage[0][0].sum * sp_damage * random_damage
          defender[:temp_hp] -= damage[0].flatten.sum * sp_damage * random_damage
          defender[:mp] -= damage[1][0].sum * sp_damage * random_damage
          defender[:temp_mp] -= damage[1].flatten.sum * sp_damage * random_damage
          defender[:sp] -= damage[2][0].sum * sp_damage * random_damage
          defender[:temp_sp] -= damage[2].flatten.sum * sp_damage * random_damage

          total_damage = damage.flatten.sum * sp_damage * random_damage

          ret[:log].push([turn, (total_damage / defender[:max_hp] * 100).to_i.to_s + "%のダメージを与えた！"])

          # 自爆ダメージ
          self_damage = move_data[:self_damage]
          attacker[:hp] -= self_damage[0][0]
          attacker[:temp_hp] -= self_damage[0].sum
          attacker[:mp] -= self_damage[1][0]
          attacker[:temp_mp] -= self_damage[1].sum
          attacker[:sp] -= self_damage[2][0]
          attacker[:temp_sp] -= self_damage[2].sum
        end
      else

        ret[:log].push([turn, attacker[:name] + "は疲れて動けない！"])

        # SP回復
        attacker[:temp_sp] += attacker[:recovery_sp] / 10
        defender[:temp_sp] += defender[:recovery_sp] / 10

      end

      [defender, attacker].each{ |t|

        t[:hp] = [t[:max_hp] / 8, [t[:hp], t[:max_hp]].min].max
        t[:mp] = [t[:max_mp] / 16, [t[:mp], t[:max_mp]].min].max
        t[:sp] = [t[:max_sp] / 4, [t[:sp], t[:max_sp]].min].max

        # 肉体的ダメージが限界の場合、精神に影響する
        if t[:temp_hp] < 0
          t[:temp_mp] += t[:temp_hp] / 10 * 2
          t[:mp] += t[:temp_hp] / 10
        end

        # 大きな精神ダメージを受けた場合、KOになる可能性がある
        if t[:temp_mp] < 0
          ko_chance = (-t[:temp_mp] / t[:mp])
          t[:ko] = rand() < ko_chance
        end

        t[:temp_hp] += (t[:hp] / t[:max_hp]) * t[:recovery_hp] / 20
        t[:temp_mp] += (t[:mp] / t[:max_mp]) * t[:recovery_mp] / 40
        t[:temp_sp] += (t[:sp] / t[:max_sp]) * t[:recovery_sp] / 10

        t[:temp_hp] = [0, [t[:temp_hp], t[:hp]].min].max
        t[:temp_mp] = [0, [t[:temp_mp], t[:mp]].min].max
        t[:temp_sp] = [t[:temp_sp], t[:sp]].min

        t[:wariness].length.times { |layer|
          t[:wariness][layer] = t[:wariness][layer] * 0.9
        }
      }

      # 攻撃側が自分の攻撃で負けないようにする
      attacker[:ko] = false

      if defender[:ko]
        ret[:log].push([-turn, defender[:name] + "はギブアップ！"])
      elsif defender[:temp_mp] == 0
        ret[:log].push([-turn, defender[:name] + "は根性で踏みとどまった！！"])
      end
    end

    ret[:log].push([nil, [t_1.clone, t_2.clone]])
    ret[:log].push([0, "試合終了！"])

    if t_2[:temp_mp] < t_1[:temp_mp]
      ret[:log].push([0, t_1[:name] + "の勝利！！"])
    else
      ret[:log].push([0, t_2[:name] + "の勝利！！"])
    end

    return ret
  end
end
