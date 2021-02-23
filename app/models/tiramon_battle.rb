class TiramonBattle < ApplicationRecord

  belongs_to :red_tiramon, class_name: 'Tiramon', foreign_key: :red, primary_key: :id
  belongs_to :blue_tiramon, class_name: 'Tiramon', foreign_key: :blue, primary_key: :id

  def getData
    return eval(data)
  end

  def self.generate(rank = -1, t_1 = Tiramon.none, t_2 = Tiramon.none, datetime = Time.current)
    battle = TiramonBattle.new
    battle.datetime = datetime
    battle.rank = rank
    battle.red = t_1.id
    battle.blue = t_2.id
    result = Tiramon.battle(t_2, t_1)
    battle.result = result[:result]
    battle.data = result.to_json

    battle.save!
  end

  def self.match_make(rank = 0)
    last_battle = TiramonBattle.where(rank: rank).order(id: :desc).first

    if last_battle.present?
      champion = last_battle.result == 1 ? last_battle.blue_tiramon : last_battle.red_tiramon
      tiramon = Tiramon.where.not(id: champion.id).where.not(tiramon_trainer: nil).sample()
    else
      tiramons = Tiramon.where.not(tiramon_trainer: nil).sample(2)
      champion = tiramons[0]
      tiramon = tiramons[1]
    end

    TiramonBattle.generate(rank, tiramon, champion, Constants::TIRAMON_FIGHT_TERM[rank].since)
  end
end
