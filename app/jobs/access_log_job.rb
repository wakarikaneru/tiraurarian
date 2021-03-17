class AccessLogJob < ApplicationJob
  queue_as :access_log

  def perform(access_datetime, ip_address, url, method, referer, user_id)
    AccessLog.create(access_datetime: access_datetime, ip_address: ip_address, url: url, method: method, referer: referer, user_id: user_id)
  end
end
