json.extract! notice, :id, :user_id, :title, :sender, :content, :read_flag, :create_datetime, :created_at, :updated_at
json.url notice_url(notice, format: :json)
