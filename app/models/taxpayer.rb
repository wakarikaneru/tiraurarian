class Taxpayer < ApplicationRecord
  belongs_to :user

  def self.generate(user_id = 0, tax = 0)
    taxpayer = Taxpayer.new

    taxpayer.user_id = user_id
    taxpayer.tax = tax

    taxpayer.save!

    TaxpayerHof.generate(user_id, tax)
  end
end
