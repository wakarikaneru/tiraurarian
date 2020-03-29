json.extract! text, :id, :tweet_id, :user_id, :content, :create_datetime, :created_at, :updated_at
json.url text_url(text, format: :json)
