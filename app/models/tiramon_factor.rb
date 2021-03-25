class TiramonFactor < ApplicationRecord

  def getFactor
    require 'matrix'
    if factor.present?
      return Vector.elements(eval(factor))
    else
      return Vector.zero(100)
    end
  end
end
