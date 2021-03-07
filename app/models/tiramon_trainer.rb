class TiramonTrainer < ApplicationRecord
  belongs_to :user
  has_many :tiramons

  def add_experience(exp)
    increment!(:experience, exp)
    self.level = [(self.experience / 100000), 0, 100].sort.second
    self.save!
  end

  def move_max
    return 3 + (self.level / 10)
  end

  def move?
    if move <= 0
      return false
    else
      decrement!(:move, 1)
      return true
    end
  end

  def use_ball?
    if tiramon_ball <= 0
      return false
    else
      decrement!(:tiramon_ball, 1)
      return true
    end
  end

  def move_recovery?(user)
    if self.user_id == user.id
      if self.user.sub_points?(Constants::TIRAMON_TRAINER_MOVE_RECOVERY_PRICE)
        self.move = self.move_max
        self.save!

        return true
      end
    end
    return false
  end

  def get_ball?(user)
    if self.user_id == user.id
      if self.user.sub_points?(Constants::TIRAMON_TRAINER_BALL_PRICE)

        increment!(:tiramon_ball, 1)
        return true
      end
    end
    return false
  end

  def self.recovery
    all_user = User.all
    all_user.find_each do |user|
      TiramonTrainer.find_or_create_by(user_id: user.id)
    end

    all_trainer = TiramonTrainer.all
    all_trainer.find_each do |trainer|
      trainer.move = 3 + (trainer.level / 10)
      trainer.save!
      Notice.generate(trainer.user_id, 0, "チラモン闘技場", "行動ポイントが回復しました。")
    end
  end

end
