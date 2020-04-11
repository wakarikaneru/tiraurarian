class Stock < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true

  # 株を購入
  def self.purchase?(user = User.none, num = 0)
    unless 0 < num
      return false
    end

    price = Control.find_or_create_by(key: "stock_price")
    price_i = price.value.to_i
    total = price_i * num
    if user.sub_points?(total)
      stock = Stock.find_or_create_by(user_id: user.id)
      stock.number = stock.number + num
      stock.save!
      return true
    else
      return false
    end
  end

  # 株を売却
  def self.sale?(user = User.none, num = 0)
    unless 0 < num
      return false
    end

    stock = Stock.find_or_create_by(user_id: user.id)
    if num <= stock.number
      stock.number = stock.number - num
      stock.save!
      price = Control.find_or_create_by(key: "stock_price")
      price_i = price.value.to_i
      total = price_i * num
      user.add_points(total)
      return true
    else
      return false
    end
  end

  # 株価変動
  def self.fluctuation
    price = Control.find_or_create_by(key: "stock_price")
    price_f = price.value.to_f

    economy = Control.find_or_create_by(key: "stock_economy")
    economy_f = economy.value.to_f

    if (Random.rand * (60 * 24 * 7)) < 1
      economy_f = Stock.rand(1) * 200
    else
      economy_f = ((economy_f + Stock.rand(1) * 10) * 0.99)
    end

    economy.update(value: economy_f.to_s)

    coefficient = Control.find_or_create_by(key: "stock_economy_coefficient")
    coefficient_f = coefficient.value.to_f

    price_target = Control.find_or_create_by(key: "stock_price_target")
    price_target_f = price_target.value.to_f

    price_f = price_f + economy_f * coefficient_f
    price_f = price_f + ((price_target_f - price_f) * 0.001)
    price_f = price_f + Stock.rand(10) * (price_target_f / 2)

    price.update(value: price_f.to_s)
    StockLog.generate(price_f.to_i)

    # 倒産
    if price_f < (price_target_f / 4) || (Random.rand * (60 * 24)) < 1
      Stock.bankruptcy
      Stock.listing
    end

  end

  # 株式上場(初期化)
  def self.listing
    count = Control.find_or_create_by(key: "company_count")
    count_s = (count.value.to_i + 1).to_s
    count.update(value: count_s)

    name = Control.find_or_create_by(key: "company_name")
    name.update(value: "株式会社チラウラリア##{count_s}")

    coefficient = Control.find_or_create_by(key: "stock_economy_coefficient")
    coefficient_f = (Stock.rand(5) * 2) + 1
    coefficient.update(value: coefficient_f.to_s)

    price_target = Control.find_or_create_by(key: "stock_price_target")
    price_target_f = (Random.rand(1000..10000))
    price_target.update(value: price_target_f.to_s)

    price = Control.find_or_create_by(key: "stock_price")
    price_f = (price_target_f + (price_target_f * Stock.rand(1)) / 2)
    price.update(value: price_f.to_s)
  end

  # 倒産
  def self.bankruptcy
    name = Control.find_or_create_by(key: "company_name")
    # 倒産を通知
    Stock.find_each do |stock|
      if 0 < stock.number
        Notice.generate(stock.user.id, 0, name.value, "#{name.value}は倒産いたしました。")
      end
    end

    Stock.delete_all
    StockLog.delete_all
  end

  def self.rand(n = 1)
    a = []
    n.times do
      a.push(Random.rand - Random.rand)
    end
    return a.sum / a.length
  end

end
