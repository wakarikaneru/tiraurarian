class TaxpayerHof < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true

  def self.generate(user_id = 0, tax = 0)
    taxpayer = TaxpayerHof.find_or_create_by(user_id: user_id)

    if taxpayer.tax <= tax
      taxpayer.tax = tax
      taxpayer.datetime = Time.current
      taxpayer.save!
    end

  end
end
