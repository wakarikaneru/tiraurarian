class User < ApplicationRecord
  before_create :format_description
  before_update :format_description

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tweets
  has_many :follows
  has_many :goods
  has_many :tags
  has_one :point

  has_many :notices
  has_many :messages

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

    max_pt = 1000000 + (all_count * 1000)

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

        notice = Notice.new
        notice.user_id = user.id
        notice.sender_id = 0
        notice.sender_name = "チラウラリア"
        notice.content = "つぶやきボーナスとして#{pt}vaを獲得しました。"
        notice.create_datetime = Time.current

        notice.save!
      end
    end

  end

  # 税金を徴収
  def self.collect_points

    tax_ratio = Constants::TAX_RATIO

    User.all.find_each do |user|
      if user.point.present?
        pt = [(user.point.point * tax_ratio).floor, Constants::TAX_MIN].max
        user.sub_points?(pt)

        notice = Notice.new
        notice.user_id = user.id
        notice.sender_id = 0
        notice.sender_name = "チラウラリア"
        notice.content = "税金として#{pt}vaを納付しました。"
        notice.create_datetime = Time.current

        notice.save!
      end
    end
  end

  private
    def format_description
      self.description.gsub!(/[\r\n|\r|\n]/, " ")
    end
end
