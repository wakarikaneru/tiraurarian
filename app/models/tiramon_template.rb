class TiramonTemplate < ApplicationRecord

  def getData
    return eval(data)
  end
  
end
