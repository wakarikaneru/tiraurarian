class TiramonTrainer < ApplicationRecord
  belongs_to :user

  def move?
    if move <= 0
      false
    else
      decrement!(:move, 1)
      true
    end
  end

  def use_ball?
    if tiramon_ball <= 0
      false
    else
      decrement!(:tiramon_ball, 1)
      true
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
