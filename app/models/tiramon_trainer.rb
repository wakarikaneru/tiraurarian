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

end
