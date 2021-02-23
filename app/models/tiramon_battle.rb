class TiramonBattle < ApplicationRecord

  belongs_to :red_tiramon, class_name: 'Tiramon', foreign_key: :red, primary_key: :id
  belongs_to :blue_tiramon, class_name: 'Tiramon', foreign_key: :blue, primary_key: :id

  def getData
    return eval(data)
  end

  def self.generate(t_1 = Tiramon.none, t_2 = Tiramon.none, datetime = Time.current)
    battle = TiramonBattle.new
    battle.datetime = datetime
    battle.red = t_1.id
    battle.blue = t_2.id
    result = Tiramon.battle(t_2, t_1)
    battle.result = result[:result]
    battle.data = result.to_json

    battle.save!
  end

  def self.match_make
    tiramons = Tiramon.where.not(tiramon_trainer: nil).sample(2)
    if tiramons.size == 2
      tiramon_1 = tiramons[0]
      tiramon_2 = tiramons[1]
      TiramonBattle.generate(tiramon_1, tiramon_2, 10.minute.since)
    end
  end
end
