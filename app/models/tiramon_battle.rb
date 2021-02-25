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
      battle.red_tiramon_name = t_2.getData[:name]
      battle.blue_tiramon_id = t_1.id
      battle.blue_tiramon_name = t_1.getData[:name]

      battle.save!
    end
  end

  def set_result()
    t_1 = Tiramon.find(self.red_tiramon_id)
    t_2 = Tiramon.find(self.blue_tiramon_id)
    r = Tiramon.battle(t_1, t_2)
    self.result = r[:result]
    self.data = r.to_json

    self.save!

    if self.result == 1
      user = self.blue_tiramon.tiramon_trainer.user
      TiramonBattlePrize.generate(user, Constants::TIRAMON_FIGHT_VARTH[self.rank], self.datetime + Constants::TIRAMON_PAYMENT_SITE - 5.minute)
    else
      user = self.red_tiramon.tiramon_trainer.user
      TiramonBattlePrize.generate(user, Constants::TIRAMON_FIGHT_VARTH[self.battle.rank], self.datetime + Constants::TIRAMON_PAYMENT_SITE - 5.minute)
    end
  end

  def self.match_make(rank = 0)
    # 王座戦の場合、前回勝者が赤コーナーにつく
    if Constants::TIRAMON_KING_RULE[rank]
      last_battle = TiramonBattle.where(rank: rank).order(id: :desc).first

      if last_battle.present?
        if last_battle.result.blank?
          last_battle.set_result
        end

        champion = last_battle.result == 1 ? last_battle.blue_tiramon : last_battle.red_tiramon
        if champion.rank != rank or champion.tiramon_trainer_id.blank?
          # 王者が階級変更、もしくは引退した場合ランダムで抽選
          champion = Tiramon.where(rank: rank).where.not(tiramon_trainer: nil).sample()
        end

        tiramon = Tiramon.where(rank: rank).where.not(id: champion.id).where.not(tiramon_trainer: nil).sample()
        TiramonBattle.generate(rank, tiramon, champion, Constants::TIRAMON_FIGHT_TERM[rank].since)
        return

      end
    end

    # 王座戦以外の場合、ランダムに抽選
    tiramons = Tiramon.where(rank: rank).where.not(tiramon_trainer: nil).sample(2)
    champion = tiramons[0]
    tiramon = tiramons[1]

    TiramonBattle.generate(rank, tiramon, champion, Constants::TIRAMON_FIGHT_TERM[rank].since)
  end

  def self.prize()
    # 完了したはずの試合の精算
    incomplete_battles = TiramonBattle.where(result: nil).where("datetime < ?", Time.current)
    incomplete_battles.find_each do |battle|
      battle.set_result
    end

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

end
