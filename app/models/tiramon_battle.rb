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
      return battle
    end
    return nil
  end

  def set_result()
    if self.result.blank?
      t_1 = Tiramon.find(self.blue_tiramon_id)
      t_2 = Tiramon.find(self.red_tiramon_id)
      r = Tiramon.battle(t_1.getData, t_2.getData)
      self.result = r[:result]
      self.data = r.to_json
      self.match_time = r[:time]

      self.save!

      if self.rank != -1
        if self.result == 1
          user = self.blue_tiramon.tiramon_trainer.user
          TiramonBattlePrize.generate(user, Constants::TIRAMON_FIGHT_VARTH[self.rank], self.datetime + Constants::TIRAMON_PAYMENT_SITE - 5.minute)
        else
          user = self.red_tiramon.tiramon_trainer.user
          TiramonBattlePrize.generate(user, Constants::TIRAMON_FIGHT_VARTH[self.rank], self.datetime + Constants::TIRAMON_PAYMENT_SITE - 5.minute)
        end
      end
    end
  end

  def self.match_make(rank = 0)

    # すでに試合が組まれている選手は除外
    scheduled_battle = TiramonBattle.where("? < datetime", Time.current)
    scheduled_tiramon_list = []
    scheduled_battle.map do |battle|
      scheduled_tiramon_list << battle.blue_tiramon_id
      scheduled_tiramon_list << battle.red_tiramon_id
    end
    scheduled_tiramon_list = scheduled_tiramon_list.uniq.sort
    scheduled_tiramons = Tiramon.where(id: scheduled_tiramon_list).where.not(tiramon_trainer: nil)

    # 王座戦の場合、前回勝者が赤コーナーにつく
    if Constants::TIRAMON_KING_RULE[rank]
      last_battle = TiramonBattle.where(rank: rank).where("datetime < ?", Time.current).order(id: :desc).first

      if last_battle.present?
        if last_battle.result.blank?
          last_battle.set_result
        end

        champion = last_battle.result == 1 ? last_battle.blue_tiramon : last_battle.red_tiramon
        if champion.rank != rank or champion.tiramon_trainer.blank? or !champion.entry
          # 王者が階級変更、もしくは引退した場合ランダムで抽選
          champion = Tiramon.where(entry: true).where(rank: rank).where.not(id: scheduled_tiramon_list).where.not(tiramon_trainer: nil).sample()
        end

        # 前回挑戦者は除外
        looser = last_battle.result == 1 ? nil : last_battle.blue_tiramon

        if looser.present?
          tiramon = Tiramon.where(entry: true).where(rank: rank).where.not(id: champion.id).where.not(id: looser.id).where.not(id: scheduled_tiramon_list).where.not(tiramon_trainer: nil).sample()
        else
          tiramon = Tiramon.where(entry: true).where(rank: rank).where.not(id: champion.id).where.not(id: scheduled_tiramon_list).where.not(tiramon_trainer: nil).sample()
        end

        # 挑戦者がいない場合のみ前回挑戦者も許可
        if tiramon.blank?
          tiramon = Tiramon.where(entry: true).where(rank: rank).where.not(id: champion.id).where.not(id: scheduled_tiramon_list).where.not(tiramon_trainer: nil).sample()
        end

        TiramonBattle.generate(rank, tiramon, champion, Constants::TIRAMON_FIGHT_TERM[rank].since)
        return

      end
    end


    if rank == 0
      # チラモンマニアの場合

      # チラモンマニアで過去1ヶ月で勝利した選手(=過去覇者)
      mania_battle = TiramonBattle.where(rank: 0).where(datetime: 1.month.ago..Time.current)
      mania_winners = []
      mania_battle.map do |battle|
        if battle.result.blank?
          battle.set_result
        end

        if battle.result == 1
          mania_winners << battle.blue_tiramon_id
        elsif battle.result == -1
          mania_winners << battle.red_tiramon_id
        else
        end
      end
      mania_winners = mania_winners.uniq.sort

      # チャンピオンシップで過去1週間で勝利した選手(=過去王者)
      championship_recent_battle = TiramonBattle.where(rank: 1).where(datetime: 7.day.ago..Time.current)
      championship_winners = []
      championship_recent_battle.map do |battle|
        if battle.result.blank?
          battle.set_result
        end

        if battle.result == 1
          championship_winners << battle.blue_tiramon_id
        elsif battle.result == -1
          championship_winners << battle.red_tiramon_id
        else
        end
      end
      championship_winners = championship_winners.uniq.sort

      # 参加資格者
      winners = mania_winners + championship_winners

      #winner_tiramons = Tiramon.where(entry: true).where(id: winners).where.not(tiramon_trainer: nil)
      #tiramons = Tiramon.none.or(winner_tiramons).where.not(id: scheduled_tiramon_list).where.not(tiramon_trainer: nil).sample(2)
      #tiramons = Tiramon.none.or(winner_tiramons).where.not(tiramon_trainer: nil).sample(2)

      tiramons = []
      tiramons[1] = Tiramon.where(entry: true).where(id: championship_winners).where.not(tiramon_trainer: nil).sample()
      tiramons[0] = Tiramon.where(entry: true).where(id: winners).where.not(id: tiramons[1].id).where.not(tiramon_trainer: nil).sample()

    else
      # それ以外の場合、ランダムに抽選
      tiramons = Tiramon.where(entry: true).where(rank: rank).where.not(id: scheduled_tiramon_list).where.not(tiramon_trainer: nil).sample(2)
    end

    champion = tiramons[0]
    tiramon = tiramons[1]
    datetime = Constants::TIRAMON_FIGHT_TERM[rank].since

    if champion.present? and tiramon.present?
      battle = TiramonBattle.generate(rank, tiramon, champion, datetime)

      if rank.in?([0, 1, 2, 3, 4])
        News.generate(1, datetime, "【チラモン】#{Constants::TIRAMON_RULE_NAME[rank]}のカードが決定。#{battle.red_tiramon_name} vs #{battle.blue_tiramon_name}。")
      end
    end
  end

  def self.ranked_match()
    # 参加資格のあるチラモン
    tiramons = Tiramon.where(entry: true).where.not(tiramon_trainer: nil)
    tiramons_count = tiramons.count

    # 欠場しているチラモンからランクを剥奪する
    miss_tiramons = Tiramon.where(entry: false).where.not(tiramon_trainer: nil)

    miss_tiramons.find_each do |tiramon|
      tiramon.update(auto_rank: nil)
    end

    # 未ランクのチラモンにランクを付ける
    unranked_tiramons = tiramons.where(auto_rank: nil)
    max_rank = tiramons.maximum(:auto_rank)
    max_rank = max_rank ? max_rank : 0

    i = 0
    unranked_tiramons.each do |tiramon|
      i = i + 1
      tiramon.update(auto_rank: max_rank + i)
    end

    # ランクの空位を圧縮する
    tiramons = tiramons.order(auto_rank: :asc)
    i = 0
    tiramons.each do |tiramon|
      i += 1
      tiramon.update(auto_rank: i)
    end

    range_width = [(tiramons_count / 10).to_i, 1].max
    t_1 = tiramons.sample
    range = (t_1.auto_rank - range_width)..(t_1.auto_rank + range_width)
    t_2 = tiramons.where(auto_rank: range).where.not(id: t_1.id).sample

    if t_1.present? and t_2.present?

      if t_1.auto_rank < t_2.auto_rank
        t_3 = t_1
        t_1 = t_2
        t_2 = t_3
      end

      battle = TiramonBattle.generate(-1, t_1, t_2, Time.current)
      battle.set_result

      News.generate(1, 5.minute.since, "【チラモン】#{battle.red_tiramon_name}(#{battle.red_tiramon.auto_rank}位) vs #{battle.blue_tiramon_name}(#{battle.blue_tiramon.auto_rank}位)のランクマッチが行われた。")

      ranks = [t_1.auto_rank, t_2.auto_rank].sort
      if battle.result == 1
        t_1.update(auto_rank: ranks[0])
        t_2.update(auto_rank: ranks[1])
      elsif battle.result == -1
        t_1.update(auto_rank: ranks[1])
        t_2.update(auto_rank: ranks[0])
      end

    end
  end

  def self.rank
    # 完了したはずの試合の精算
    incomplete_battles = TiramonBattle.where(result: nil).where("datetime < ?", Time.current)
    incomplete_battles.find_each do |battle|
      battle.set_result
    end

    tiramons = Tiramon.where(entry: true).where.not(tiramon_trainer: nil)
    arr = []

    tiramons.each do |tiramon|
      blue = TiramonBattle.where(blue_tiramon: tiramon)
      red = TiramonBattle.where(red_tiramon: tiramon)
      today_battles = TiramonBattle.none.or(blue).or(red).where(datetime: Time.current.all_day).where("datetime < ?", Time.current)

      win_blue = today_battles.where(blue_tiramon: tiramon).where(result: 1)
      win_red = today_battles.where(red_tiramon: tiramon).where(result: -1)
      draw = today_battles.where(result: 0)

      if today_battles.count == 0
        score = 0.5
      else
        score = ((win_blue.count + win_red.count) + (draw.count * 0.5)) / (today_battles.count)
      end

      arr << [tiramon.id, tiramon.rank, score, rand()]
    end

    arr = arr.sort_by {|x| [x[1], -x[2], x[3]]}

    (1..6).each do |rank|
      i = arr.rindex{|x| x[1] == rank}
      if !i.nil?
        arr[i][1] = rank + 1
        arr[i][2] = 0.5
      end
    end

    arr = arr.sort_by {|x| [x[1], -x[2], x[3]]}

    (1..6).each do |rank|
      Constants::TIRAMON_RULE_CAPACITY[rank].times do
        a = arr.shift
        if a.nil?
          break
        end
        t = Tiramon.find(a[0])
        t.update(rank: rank)
      end
    end

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
        dividend = (varth.to_f / (1.0 + tiramons.count).to_f)
        user.add_points(dividend.to_i)
        trainer.add_experience(varth.to_i)
        Notice.generate(user.id, 0, "チラモン闘技場", "賞金として" + varth.to_i.to_s + "va獲得しました。" + "チラモンたちと山分けして" + dividend.to_i.to_s + "va手に入れました。")
      end
    end

    prizes.delete_all
  end

end
