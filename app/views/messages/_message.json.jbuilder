json.extract! message, :id, :user_id, :sender, :title, :content, :read_flag, :create_datetime, :created_at, :updated_at
json.url message_url(message, format: :json)
