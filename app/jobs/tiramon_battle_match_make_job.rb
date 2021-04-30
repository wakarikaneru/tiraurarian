class TiramonBattleMatchMakeJob < ApplicationJob
  queue_as :tiramon_battle_match_make

  def perform(rank)

    case rank
    when -1 then
      # ランクマッチ
      TiramonBattle.ranked_match
    when 0 then
      # チラモンマニア
      TiramonBattle.match_make(0)

      battle = TiramonBattle.where(rank: 0).order(datetime: :desc).first
      TiramonBet.generate(battle, nil, 1, 10000)
      TiramonBet.generate(battle, nil, -1, 10000)
    when 1,2,3,4 then
      # 王座戦
      TiramonBattle.match_make(rank)
    when 5,6 then
      # 一般試合
      roster = Tiramon.where(entry: true).where(rank: rank).where.not(tiramon_trainer: nil).count
      match_num = [(roster.to_f / 16.0).ceil, 1.0].max.to_i
      match_num.times do
        TiramonBattle.match_make(rank)
      end
    else
    end

  end
end
