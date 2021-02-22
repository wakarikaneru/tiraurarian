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
        element_0: [d[:damage][0][0][0], d[:damage][0][1][0], d[:damage][1][0][0], d[:damage][1][1][0], d[:damage][2][0][0], d[:damage][2][1][0]].sum,
        element_1: [d[:damage][0][0][1], d[:damage][0][1][1], d[:damage][1][0][1], d[:damage][1][1][1], d[:damage][2][0][1], d[:damage][2][1][1]].sum,
        element_2: [d[:damage][0][0][2], d[:damage][0][1][2], d[:damage][1][0][2], d[:damage][1][1][2], d[:damage][2][0][2], d[:damage][2][1][2]].sum,
      },
      self_damage: {
        hp: d[:self_damage][0][0].to_f,
        thp: d[:self_damage][0][1].to_f,
        mp: d[:self_damage][1][0].to_f,
        tmp: d[:self_damage][1][1].to_f,
        sp: d[:self_damage][2][0].to_f,
        tsp: d[:self_damage][2][1].to_f,
        total: d[:self_damage].flatten.sum,
      },
      element: 4,
    }

    a = [m[:damage][:element_0], m[:damage][:element_1], m[:damage][:element_2]]
    m[:element] = a.index(a.max)

    return m
  end

end
