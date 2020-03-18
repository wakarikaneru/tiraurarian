class AccessLogJob < ApplicationJob
  queue_as :default

  def perform(access_datetime, ip_address, url, method, referer, user_id)
    access_count = Control.find_or_create_by(key: "access_count")
    access_count.update(value: (access_count.value.to_i + 1).to_s)

    access_log = AccessLog.new
    access_log.access_datetime = access_datetime
    access_log.ip_address = ip_address
    access_log.url = url
    access_log.method = method
    access_log.referer = referer
    access_log.user_id = user_id
    access_log.save!
  end
end
