class TiramonMove < ApplicationRecord

  def getData
    return eval(data)
  end

end
