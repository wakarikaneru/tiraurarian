class TiramonEnemy < ApplicationRecord

  def getData
    return eval(data)
  end

end
