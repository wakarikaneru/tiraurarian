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
    battle.red = t_2.id
    battle.blue = t_1.id
    result = Tiramon.battle(t_1, t_2)
    battle.result = result[:result]
    battle.data = result.to_json

    battle.payment = false
    battle.payment_time = datetime + Constants::TIRAMON_PAYMENT_SITE - 5.minute

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

  def self.prize()
    battles = TiramonBattle.where(payment: false).where("payment_time < ?", Time.current).where.not(rank: nil)

    total_prizes = []
    battles.find_each do |battle|
      user_id = 0
      if battle.result == 1
        user_id = battle.blue_tiramon.tiramon_trainer.user_id
      else
        user_id = battle.red_tiramon.tiramon_trainer.user_id
      end

      total_prize = total_prizes.find{|m| m[:user_id] == user_id}
      if total_prize.blank?
        total_prizes << {user_id: user_id, value: Constants::TIRAMON_FIGHT_VARTH[battle.rank]}
      else
        total_prize[:value] += Constants::TIRAMON_FIGHT_VARTH[battle.rank]
      end

      battle.update(payment: true)
    end

    total_prizes.map do |total_prize|
      user = User.find_by(id: total_prize[:user_id])
      if user.present?
        user.add_points(total_prize[:value])
        Notice.generate(user.id, 0, "チラモン闘技場", "賞金として" + total_prize[:value].to_i.to_s + "va手に入れました。")
      end
    end

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
