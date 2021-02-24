class TiramonMove < ApplicationRecord

  def getData
    return eval(data)
  end

  def self.getMoveData(data)
    d = data
    m = {
      id: d[:id],
      name: d[:name],
      damage: {
        hp: d[:damage][0][0],
        thp: d[:damage][0][1],
        mp: d[:damage][1][0],
        tmp: d[:damage][1][1],
        sp: d[:damage][2][0],
        tsp: d[:damage][2][1],
        element_0: [d[:damage][0][0][0].to_f, d[:damage][0][1][0].to_f, d[:damage][1][0][0].to_f, d[:damage][1][1][0].to_f, d[:damage][2][0][0].to_f, d[:damage][2][1][0].to_f].sum,
        element_1: [d[:damage][0][0][1].to_f, d[:damage][0][1][1].to_f, d[:damage][1][0][1].to_f, d[:damage][1][1][1].to_f, d[:damage][2][0][1].to_f, d[:damage][2][1][1].to_f].sum,
        element_2: [d[:damage][0][0][2].to_f, d[:damage][0][1][2].to_f, d[:damage][1][0][2].to_f, d[:damage][1][1][2].to_f, d[:damage][2][0][2].to_f, d[:damage][2][1][2].to_f].sum,
      },
      self_damage: {
        hp: d[:self_damage][0][0].to_f,
        thp: d[:self_damage][0][1].to_f,
        mp: d[:self_damage][1][0].to_f,
        tmp: d[:self_damage][1][1].to_f,
        sp: d[:self_damage][2][0].to_f,
        tsp: d[:self_damage][2][1].to_f,
      },
      move_value_attack: 0.0,
      move_value_all: 0.0,
      element: 3,
    }

    m[:move_value_attack] = TiramonMove.get_risk(m[:damage])
    m[:move_value_all] = TiramonMove.get_risk(m[:damage]) - TiramonMove.get_risk_self(m[:self_damage])

    a = [m[:damage][:element_0], m[:damage][:element_1], m[:damage][:element_2]]
    m[:element] = 0 < a.max ? a.index(a.max) : 3

    return m
  end

  def self.get_risk(d = {})
    v = Constants::TIRAMON_MOVE_VALUE
    return [d[:hp].sum * v[0], d[:thp].sum * v[1], d[:mp].sum * v[2], d[:tmp].sum * v[3], d[:sp].sum * v[4], d[:tsp].sum * v[5]].sum.to_f
  end
  def self.get_risk_self(d = {})
    v = Constants::TIRAMON_MOVE_VALUE
    return [d[:hp] * v[0], d[:thp] * v[1], d[:mp] * v[2], d[:tmp] * v[3], d[:sp] * v[4], d[:tsp] * v[5]].sum.to_f
  end

end
