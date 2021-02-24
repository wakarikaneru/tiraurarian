class TiramonBattle < ApplicationRecord

  belongs_to :red_tiramon, class_name: 'Tiramon', foreign_key: :red_tiramon_id, primary_key: :id
  belongs_to :blue_tiramon, class_name: 'Tiramon', foreign_key: :blue_tiramon_id, primary_key: :id

  def getData
    return eval(data)
  end

  def self.generate(rank = -1, t_1 = Tiramon.none, t_2 = Tiramon.none, datetime = Time.current)
    if t_1.present? and t_2.present?
      battle = TiramonBattle.new
      battle.datetime = datetime
      battle.rank = rank
      battle.red_tiramon_id = t_2.id
      battle.blue_tiramon_id = t_1.id
      result = Tiramon.battle(t_1, t_2)
      battle.result = result[:result]
      battle.data = result.to_json

      battle.save!

      if battle.result == 1
        user = battle.blue_tiramon.tiramon_trainer.user
        TiramonBattlePrize.generate(user, Constants::TIRAMON_FIGHT_VARTH[battle.rank], datetime + Constants::TIRAMON_PAYMENT_SITE - 5.minute)
      else
        user = battle.red_tiramon.tiramon_trainer.user
        TiramonBattlePrize.generate(user, Constants::TIRAMON_FIGHT_VARTH[battle.rank], datetime + Constants::TIRAMON_PAYMENT_SITE - 5.minute)
      end
    end
  end

  def self.match_make(rank = 0)
    last_battle = TiramonBattle.where(rank: rank).order(id: :desc).first

    if last_battle.present?
      champion = last_battle.result == 1 ? last_battle.blue_tiramon : last_battle.red_tiramon
      if rank == 0
        tiramon = Tiramon.where.not(id: champion.id).where.not(tiramon_trainer: nil).sample()
      else
        tiramon = Tiramon.where(rank: rank).where.not(id: champion.id).where.not(tiramon_trainer: nil).sample()
      end
    else
      if rank == 0
        tiramons = Tiramon.where.not(tiramon_trainer: nil).sample(2)
      else
        tiramons = Tiramon.where(rank: rank).where.not(tiramon_trainer: nil).sample(2)
      end
      champion = tiramons[0]
      tiramon = tiramons[1]
    end

    TiramonBattle.generate(rank, tiramon, champion, Constants::TIRAMON_FIGHT_TERM[rank].since)
  end

  def self.prize()
    prizes = TiramonBattlePrize.where("datetime < ?", Time.current)
    prizes_group = prizes.group(:user_id).sum(:prize)

    prizes_group.map do |id, varth|
      user = User.find_by(id: id)
      if user.present?
        user.add_points(varth)
        Notice.generate(user.id, 0, "チラモン闘技場", "賞金として" + varth.to_i.to_s + "va手に入れました。")
      end
    end

    prizes.delete_all
  end

  def self.recovery
    all_user = User.all
    all_user.find_each do |user|
      TiramonTrainer.find_or_create_by(user_id: user.id)
    end

    all_trainer = TiramonTrainer.all
    all_trainer.find_each do |trainer|
      trainer.move = 3 + (trainer.level / 10)
      trainer.tiramon_ball = trainer.tiramon_ball + 1
      trainer.save!
      Notice.generate(trainer.user_id, 0, "チラモン闘技場", "行動ポイントが回復しました。")
    end
  end
end
