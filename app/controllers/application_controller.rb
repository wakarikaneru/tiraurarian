class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :access_log
  before_action :detect_locale
  before_action :notification_counts
  before_action :get_news
  before_action :user_point
  before_action :create_thumb
  before_action :check_premium

  def detect_locale
    @locale = session[:locale]
    if @locale == nil
      acceptLanguage = request.headers['Accept-Language']
      unless acceptLanguage.nil?
        I18n.locale = acceptLanguage.scan(/\A[a-z]{2}/).first
      end
    else
      I18n.locale = @locale
    end
  end

  def set_locale
    session[:locale] = params[:locale]
  end

  def notification
    render json: @notification
  end

  def news
    render json: @news
  end

  def stat
    stat = Stat.order(id: :desc).limit(60)
    stats = []
    stat.map do |s|
      stats.push({datetime: s.datetime.to_s, load: s.load, users: s.users})
    end
    render json: stats
  end

  def offline
  end

  def load
    stat = Stat.order(id: :desc).first
    @load = stat.load
    case @load
    when 0..500
        @load_str = "低負荷"
      when 501..1000
        @load_str = "中負荷"
      when 1001..1500
        @load_str = "高負荷"
      when 1501..2000
        @load_str = "超負荷"
      when 2001..2500
        @load_str = "やばい"
      else
        @load_str = "未知の領域"
    end
    render partial: "layouts/load"
  end

  def active_users
    @active_users = User.none
    @active_anonyms_count = 0
    @active_users_count = @active_users.count
    @active_total_count = @active_users_count + @active_anonyms_count
    render partial: "layouts/active_users"
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:login_id, :name, :avatar, :description])
      devise_parameter_sanitizer.permit(:account_update, keys: [:login_id, :name, :avatar, :description])
    end

    def access_log
      if user_signed_in?
        user_id = current_user.id
      else
        user_id = 0
      end
      AccessLogJob.perform_later(Time.current.to_s, request.remote_ip, request.url, request.method, request.referer, user_id)
    end

    def create_thumb
      key = Date.today.to_s + ":" + request.remote_ip
      if Thumb.find_by(key: key).present?
      else
        CreateThumbJob.perform_later(key)
      end
    end

    def user_point
      if user_signed_in?
        @user_points = Point.find_or_create_by(user_id: current_user.id).point
      else
        @user_points = 0
      end
    end

    def check_premium
      if user_signed_in?
        @is_premium = Premium.where(user_id: current_user.id).where("? <= limit_datetime", Time.current).present?
      else
        @is_premium = false
      end
    end

    def authenticate_premium!
      if user_signed_in?
        unless check_premium
          redirect_to premium_path, alert: "プレミアム会員専用ページです。"
        end
      else
        redirect_to new_user_session_path, alert: 'ログインしてください。'
      end
    end

    def authenticate_admin!
      # TODO Add authentication logic here.
      if user_signed_in? && current_user.id == 1
      else
        redirect_to root_path
      end
    end

    def notification_counts
      if user_signed_in? then
        my_mutes = Mute.where(user_id: current_user.id).select(:target_id)

        receive_notices = Notice.where(user_id: current_user.id).where(read_flag: false)
        notices = Notice.none.or(receive_notices).where.not(sender_id: my_mutes)

        receive_messages = Message.where(user_id: current_user.id).where(read_flag: false)
        messages = Message.none.or(receive_messages).where.not(sender_id: my_mutes)

        notice_records = Notice.none.or(notices).where("create_datetime > ?", Constants::NOTICE_RETENTION_PERIOD.ago)
        message_records = Message.none.or(messages).where("create_datetime > ?", Constants::MESSAGE_RETENTION_PERIOD.ago)

        my_tweets = Tweet.where(user_id: current_user.id)
        my_tweets_res = Tweet.where(parent_id: my_tweets)
        res_records = Tweet.none.or(my_tweets_res).where.not("id <= ?", current_user.last_check_res).where.not(user_id: current_user.id).where.not(user_id: my_mutes)

        last_check = session[:last_check_tweet].present? ? session[:last_check_tweet].to_i : Tweet.all.maximum(:id)
        tweets = Tweet.where("id > ?", last_check).where.not(user_id: current_user.id).where.not(user_id: my_mutes)
      else
        notice_records = Notice.none
        message_records = Message.none
        res_records = Tweet.none

        last_check = session[:last_check_tweet].present? ? session[:last_check_tweet].to_i : Tweet.all.maximum(:id)
        tweets = Tweet.where("id > ?", last_check).where.not(user_id: my_mutes)
      end

      notice_count = notice_records.count
      message_count = message_records.count
      res_count = res_records.count
      unread_count = tweets.count

      @notification = {datetime: Time.current.to_s, last_check:session[:last_check_tweet].to_i, unread: unread_count, res: res_count, notice: notice_count, message: message_count}
    end

    def get_news
      @news = News.where("expiration > ?", Time.current)
    end
end
