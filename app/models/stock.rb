class Stock < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true

  # 株を購入
  def self.purchase?(user = User.none, num = 0)
    unless 0 < num
      return false
    end

    Stock.determine
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

    Stock.determine
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
    recent_stock = StockLog.order(datetime: :desc).first
    if recent_stock.blank?
      recent_stock = StockLog.generate(Time.current)
    end

    datetime = recent_stock.datetime
    buffer_time = Time.current + 5.minute
    while datetime < buffer_time  do
      datetime = datetime + Constants::STOCK_UPDATE_SECOND.second
      StockLog.generate(datetime)
    end
  end

  def self.determine
    StockLog.where(point: nil).where("datetime < ?", Time.current).order(datetime: :desc).map do |log|
      Stock.set_log(log)
    end
  end

  def self.set_log(stock_log)

    price = Control.find_or_create_by(key: "stock_price")
    price_f = price.value.to_f

    economy = Control.find_or_create_by(key: "stock_economy")
    economy_f = economy.value.to_f

    appearance_economy = Control.find_or_create_by(key: "stock_appearance_economy")
    appearance_economy_f = appearance_economy.value.to_f

    if (Random.rand * ((60.0 / Constants::STOCK_UPDATE_SECOND.to_f) * 60 * 12)) < 1
      economy_f = dist_rand(1) * 200
      appearance_economy_f = dist_rand(1) * 200
    else
      economy_f = ((economy_f + dist_rand(2) * 10) * 0.99) * (Constants::STOCK_UPDATE_SECOND.to_f / 60.0)
      appearance_economy_f = ((economy_f + dist_rand(2) * 10) * 0.99) * (Constants::STOCK_UPDATE_SECOND.to_f / 60.0)
    end

    economy.update(value: economy_f.to_s)
    appearance_economy.update(value: appearance_economy_f.to_s)

    coefficient = Control.find_or_create_by(key: "stock_economy_coefficient")
    coefficient_f = coefficient.value.to_f

    price_target = Control.find_or_create_by(key: "stock_price_target")
    price_target_f = price_target.value.to_f

    price_f = price_f + (economy_f * coefficient_f) * 1.0 * (Constants::STOCK_UPDATE_SECOND.to_f / 60.0)
    price_f = price_f + ((price_target_f - price_f) * 0.01)# * (Constants::STOCK_UPDATE_SECOND.to_f / 60.0)
    price_f = price_f + dist_rand(20) * (price_target_f / 2.0)# * (Constants::STOCK_UPDATE_SECOND.to_f / 60.0)

    price.update(value: price_f.to_s)
    stock_log.set_point(price_f.to_i)

    # 倒産確率変動
    bankruptcy_day = [(price_f / 10000.0) * 7, 1.0, 7.0].sort.second * 7

    # 倒産
    if price_f < (price_target_f / 2) || (Random.rand * ((60.0 / Constants::STOCK_UPDATE_SECOND.to_f) * 60 * 24 * bankruptcy_day)) < 1
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
    name.update(value: Stock.randomName)

    coefficient = Control.find_or_create_by(key: "stock_economy_coefficient")
    coefficient_f = 1 - (Random.rand * Random.rand) * 2
    coefficient.update(value: coefficient_f.to_s)

    price_target = Control.find_or_create_by(key: "stock_price_target")
    price_target_f = (Random.rand(100..10000))
    price_target.update(value: price_target_f.to_s)

    price = Control.find_or_create_by(key: "stock_price")
    price_f = price_target_f + ((price_target_f * dist_rand(2)) / 2)
    price.update(value: price_f.to_s)

    Stock.fluctuation
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

  def self.dist_rand(n = 1)
    a = []
    n.times do
      a.push(Random.rand - Random.rand)
    end
    return a.sum / a.length
  end

  def self.randomName()
    a = []

    if Random.rand() < 0.5
      a << "ウラリア"
    else
      a << "チラウラリア"
    end

    a.concat(Constants::STOCK_COMPANY_NAME_ELEMENTS.sample(Random.rand(1..3)))

    a.shuffle!

    if Random.rand() < 0.1
      a << Constants::STOCK_COMPANY_NAME_ELEMENTS_AFTER.sample()
    end

    if Random.rand() < 0.5
      a.prepend("株式会社")
    else
      a.append("株式会社")
    end

    return a.join
  end
end
