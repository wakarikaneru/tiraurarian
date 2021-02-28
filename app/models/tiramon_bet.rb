class TiramonBet < ApplicationRecord
  belongs_to :tiramon_battle
  belongs_to :user, optional: true

  def self.bet(user, bet, bet_amount)
    battle = TiramonBattle.where(rank: 0).where("datetime > ?", Time.current).order(datetime: :asc).first
    already_bet = TiramonBet.where(tiramon_battle: battle, user: user)
    if battle.present? and !already_bet.present?
      if user.sub_points?(bet_amount)
        TiramonBet.generate(battle, user, bet, bet_amount)
        return true
      end
    end
    return false
  end

  def self.odds(battle, bet)
    bet_total = TiramonBet.where(tiramon_battle: battle).sum(:bet_amount)
    bet = TiramonBet.where(tiramon_battle: battle).where(bet: bet).sum(:bet_amount)
    odds = bet_total.to_f / bet.to_f * 0.95
    return odds.floor(2)
  end

  def self.generate(battle, user, bet, bet_amount)
    if battle.present?
      b = TiramonBet.new
      b.tiramon_battle = battle
      b.user = user
      b.bet = bet
      b.bet_amount = bet_amount

      b.save!
    end
  end

  def self.pay_off(battle)
    result = battle.result
    bets = TiramonBet.where(tiramon_battle: battle)
    bet_total = TiramonBet.where(tiramon_battle: battle).sum(:bet_amount)
    bet_win = TiramonBet.where(tiramon_battle: battle).where(bet: result).sum(:bet_amount)
    odds = bet_total.to_f / bet_win.to_f * 0.95

    bets.find_each do |bet|
      if bet.bet == result
        if bet.user.present?
          user = bet.user
          win = (bet.bet_amount * odds).to_i
          user.add_points(win)
          Notice.generate(user.id, 0, "チラモンマニア賭博", "予想的中！！配当金として" + win.to_i.to_s + "va手に入れました。")
        end
      end
    end

    bets.delete_all
  end

end
