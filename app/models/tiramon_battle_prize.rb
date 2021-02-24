class TiramonBattlePrize < ApplicationRecord
  belongs_to :user

  def self.generate(user = User.none, varth, datetime)
    prize = TiramonBattlePrize.new
    prize.datetime = datetime
    prize.user = user
    prize.prize = varth

    prize.save!
  end
end
