class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_create :format_description
  before_update :format_description

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_logs

  has_many :tweets
  has_many :texts
  has_many :follows, dependent: :destroy
  has_many :goods, dependent: :destroy
  has_many :bads, dependent: :destroy
  has_many :tags
  has_one :point, dependent: :destroy

  has_many :notices
  has_many :messages

  has_one :card_box, dependent: :destroy

  validates :login_id, presence: true, uniqueness: true, length: { in: 1..16 }, format: { with: /\A[a-zA-Z\d_]+\z/ }
  validates :name, length: { maximum: 16 }
  validates :description, length: { maximum: 140 }

  has_attached_file :avatar, url: "/system/images/:hash.:extension", hash_secret: "longSecretString", styles: { large: "1024x1024>", medium: "512x512>", thumb_large: "128x128#", thumb: "64x64#" }, default_url: "/images/mystery-person.png"
  do_not_validate_attachment_file_type :avatar

  def avatar_from_url(url)
    self.avatar = open(url)
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def update_last_tweet
    self.update(last_tweet: Time.current)
  end

  def is_premium()
    return Premium.where(user_id: self.id).where("? <= limit_datetime", Time.current).present?
  end

  def add_points(pt = 0)
    points = Point.find_or_create_by(user_id: self.id)
    points.increment!(:point, pt)
  end

  def sub_points?(pt = 0)
    points = Point.find_or_create_by(user_id: self.id)
    if points.point < pt
      false
    else
      points.decrement!(:point, pt)
      true
    end
  end

  def send_points?(to = User.none, pt = 0)
    if to.is_a?(User) && to.present?
      if self.sub_points?(pt)
        to.add_points(pt)
        true
      else
        false
      end
    else
      false
    end
  end

  # ポイント配布
  def self.distribute_points

    all_user = User.all
    all_count = all_user.count

    max_pt = 10000000 + (all_count * 10000)

    all_pt = Point.all.sum(:point)
    distribute_ratio = Constants::DISTRIBUTE_RATIO
    distribute_pt = [(max_pt - all_pt) * distribute_ratio, 0].max

    control_last_distribute = Control.find_or_create_by(key: "last_distribute")
    last_distribute = control_last_distribute.value.to_i
    target_tweet = Tweet.where("id > ?", last_distribute)
    if target_tweet.any?
      control_last_distribute.update(value: target_tweet.maximum(:id).to_s)
    end

    target_user = User.where(id: target_tweet.select("user_id").distinct)
    target_count = target_user.count

    if 0 < target_count
      pt = [(distribute_pt / target_count).floor, Constants::DISTRIBUTE_MIN].max

      target_user.find_each do |user|
        user.add_points(pt)
        Notice.generate(user.id, 0, "チラウラリア", "つぶやきボーナスとして#{pt}vaを獲得しました。")
      end
    end

  end

  # 税金を徴収
  def self.collect_points

    all_user = User.all
    all_count = all_user.count

    max_pt = 10000000 + (all_count * 10000)
    all_pt = Point.all.sum(:point)
    d_pt = [0, all_pt - max_pt].max
    over_ratio = d_pt.to_f / (d_pt.to_f + max_pt.to_f)

    tax_ratio = [Constants::TAX_RATIO, over_ratio].max

    Taxpayer.delete_all

    User.all.find_each do |user|
      if user.point.present?
        pt = [(user.point.point * tax_ratio).floor, Constants::TAX_MIN].max
        if user.sub_points?(pt)
          Notice.generate(user.id, 0, "チラウラリア", "チラウラリア税として#{pt}vaを納付しました。")
          Taxpayer.generate(user.id, pt)
        end
      end
    end
  end

  private
    def format_description
      self.description.gsub!(/[\r\n|\r|\n]/, " ")
    end
end
