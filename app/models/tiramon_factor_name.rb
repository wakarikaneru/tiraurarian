class TiramonFactorName < ApplicationRecord

  def getFactorNameList
    if factor.present?
      return eval(factor)
    else
      return []
    end
  end
  
end
