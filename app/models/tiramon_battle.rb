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
    if self.result.blank?
      t_1 = Tiramon.find(self.blue_tiramon_id)
      t_2 = Tiramon.find(self.red_tiramon_id)
      r = Tiramon.battle(t_1, t_2)
      self.result = r[:result]
      self.data = r.to_json

      self.save!

      if self.result == 1
        user = self.blue_tiramon.tiramon_trainer.user
        TiramonBattlePrize.generate(user, Constants::TIRAMON_FIGHT_VARTH[self.rank], self.datetime + Constants::TIRAMON_PAYMENT_SITE - 5.minute)
      else
        user = self.red_tiramon.tiramon_trainer.user
        TiramonBattlePrize.generate(user, Constants::TIRAMON_FIGHT_VARTH[self.rank], self.datetime + Constants::TIRAMON_PAYMENT_SITE - 5.minute)
      end
    end
  end

  def self.match_make(rank = 0)
    # 王座戦の場合、前回勝者が赤コーナーにつく
    if Constants::TIRAMON_KING_RULE[rank]
      last_battle = TiramonBattle.where(rank: rank).where("datetime < ?", Time.current).order(id: :desc).first

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

    if rank == 0
      # チラモンマニアの場合、チャンピオンシップで過去1週間で勝利した選手のみ
      recent_battle = TiramonBattle.where(rank: 1).where(datetime: 7.day.ago..Time.current).order(id: :desc)
      winners = []
      recent_battle.map do |battle|
        if battle.result.blank?
          battle.set_result
        end

        if battle.result == 1
          winners << battle.blue_tiramon_id
        elsif battle.result == -1
          winners << battle.red_tiramon_id
        else
        end
      end

      winner_tiramons = Tiramon.where(id: winners).where.not(tiramon_trainer: nil)
      tiramons = Tiramon.none.or(winner_tiramons).where.not(tiramon_trainer: nil).sample(2)

    elsif rank == 3
      # ノーマルマッチの場合、アンダーで過去1時間で勝利した選手も含める
      recent_battle = TiramonBattle.where(rank: 4).where(datetime: 1.hour.ago..Time.current).order(id: :desc)
      winners = []
      recent_battle.map do |battle|
        if battle.result.blank?
          battle.set_result
        end

        if battle.result == 1
          winners << battle.blue_tiramon_id
        elsif battle.result == -1
          winners << battle.red_tiramon_id
        else
        end
      end

      winner_tiramons = Tiramon.where(id: winners).where.not(tiramon_trainer: nil)
      tiramons = Tiramon.where(rank: rank).or(winner_tiramons).where.not(tiramon_trainer: nil).sample(2)
    elsif rank == 4
      # アンダーマッチの場合、ノーマルで1時間で敗北した選手も含める
      recent_battle = TiramonBattle.where(rank: 3).where(datetime: 1.hour.ago..Time.current).order(id: :desc)
      loosers = []
      recent_battle.map do |battle|
        if battle.result.blank?
          battle.set_result
        end

        if battle.result == 1
          loosers << battle.red_tiramon_id
        elsif battle.result == -1
          loosers << battle.blue_tiramon_id
        else
        end
      end

      looser_tiramons = Tiramon.where(id: loosers).where.not(tiramon_trainer: nil)
      tiramons = Tiramon.where(rank: rank).or(looser_tiramons).where.not(tiramon_trainer: nil).sample(2)
    else
      # それ以外の場合、ランダムに抽選
      tiramons = Tiramon.where(rank: rank).where.not(tiramon_trainer: nil).sample(2)
    end

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
        trainer = TiramonTrainer.find_or_create_by(user_id: user.id)
        tiramons = Tiramon.where(tiramon_trainer_id: trainer.id)
        dividend = (varth.to_f / (1.0 + tiramons.count).to_f).to_i
        user.add_points(dividend)
        Notice.generate(user.id, 0, "チラモン闘技場", "賞金として" + varth.to_i.to_s + "va獲得しました。" + "チラモンたちと山分けして" + dividend.to_i.to_s + "va手に入れました。")
      end
    end

    prizes.delete_all
  end

end
