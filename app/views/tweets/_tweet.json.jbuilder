json.extract! tweet, :id, :user_id, :parent_id, :content, :create_datetime, :created_at, :updated_at
json.url tweet_url(tweet, format: :json)
