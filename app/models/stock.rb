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
      economy_f = dist_rand(1) * 200.0
      appearance_economy_f = dist_rand(1) * 200.0
    else
      economy_f = economy_f + (dist_rand(3) * 10.0) * (Constants::STOCK_UPDATE_SECOND.to_f / 60.0)
      economy_f = economy_f - (economy_f * 0.01) * (Constants::STOCK_UPDATE_SECOND.to_f / 60.0)
      appearance_economy_f = appearance_economy_f + (dist_rand(3) * 10.0) * (Constants::STOCK_UPDATE_SECOND.to_f / 60.0)
      appearance_economy_f = appearance_economy_f - (appearance_economy_f * 0.01) * (Constants::STOCK_UPDATE_SECOND.to_f / 60.0)
    end

    economy.update(value: economy_f.to_s)
    appearance_economy.update(value: appearance_economy_f.to_s)

    coefficient = Control.find_or_create_by(key: "stock_economy_coefficient")
    coefficient_f = coefficient.value.to_f

    price_target = Control.find_or_create_by(key: "stock_price_target")
    price_target_f = price_target.value.to_f

    price_target_f = price_target_f + (economy_f * coefficient_f * 0.1)
    price_target.update(value: price_target_f.to_s)

    price_f = price_f + (economy_f * coefficient_f) * 1.0 * (Constants::STOCK_UPDATE_SECOND.to_f / 60.0)
    price_f = price_f + ((price_target_f - price_f) * 0.05) * (Constants::STOCK_UPDATE_SECOND.to_f / 60.0)
    price_f = price_f + dist_rand(5) * (price_target_f / 5.0) * (Constants::STOCK_UPDATE_SECOND.to_f / 60.0)

    price.update(value: price_f.to_s)
    stock_log.set_point(price_f.to_i)

    # 倒産確率変動
    bankruptcy_day = [(price_f / 10000.0) * 7.0, 1.0, 7.0].sort.second

    # 倒産
    if price_target_f < 500.0 || price_f < (price_target_f / 2.0) || (Random.rand * ((60.0 / Constants::STOCK_UPDATE_SECOND.to_f) * 60.0 * 24.0 * bankruptcy_day)) < 1.0
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
    coefficient_f = 1.0 - (Random.rand * Random.rand) * 2.0
    coefficient.update(value: coefficient_f.to_s)

    price_target = Control.find_or_create_by(key: "stock_price_target")
    price_target_f = (Random.rand(1000..10000))
    price_target.update(value: price_target_f.to_s)

    price = Control.find_or_create_by(key: "stock_price")
    price_f = price_target_f + ((price_target_f * dist_rand(2)) / 2.0)
    price.update(value: price_f.to_s)

    News.generate(1, Time.current + 10.minute, "【株】#{name.value}が上場。売出価格は#{price.value.to_i.to_s}va。")

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

    News.generate(2, Time.current + 5.minute, "【株】#{name.value}が倒産。")

    Stock.delete_all
    StockLog.delete_all
  end

  # ニュース
  def self.news
    Stock.determine
    stock_number = Control.find_or_create_by(key: "company_count").value
    stock_name = Control.find_or_create_by(key: "company_name").value
    recent_stock = StockLog.where.not(point: nil).order(datetime: :desc).first
    if recent_stock.present?
      before_stock = StockLog.where("? < datetime", recent_stock.datetime - 10.minute).where.not(point: nil).order(datetime: :asc).first
      if before_stock.present?
        diff = recent_stock.point.to_i - before_stock.point.to_i
        price = recent_stock.point.to_i
        rate = (diff.to_f / price.to_f) * 100.0
        if 0 < diff
          arrow = "↑"
          sign = "+"
        else
          arrow = "↓"
          sign = ""
        end
        News.generate(1, Time.current + 10.minute, "【株】 [#{stock_number.to_s}]#{stock_name} #{price.to_s} 10分前比 #{arrow} #{sign}#{diff.to_s} (#{sign}#{rate.floor(2).to_s}%) " + Time.current.strftime("%Y年%m月%d日 %H:%M:%S") + "現在")
      end
    end
  end

  def self.dist_rand(n = 1)
    a = []
    r = Random.new
    n.times do
      a.push(r.rand() - r.rand())
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
