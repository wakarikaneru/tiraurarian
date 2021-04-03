class BotController < ApplicationController

  require 'net/http'
  require 'uri'
  require 'json'

  CLIENT_ID = ENV["A3RT_API_KEY"]

  def self.talk_bot
    # つぶやきを選択
    last_res_id = Control.find_or_create_by(key: "bot_last_res_id")
    last_res_id_i = last_res_id.value.to_i

    my_tweets = Tweet.where(user_id: -1)
    my_tweets_res = Tweet.where(parent_id: my_tweets)
    res_tweets = Tweet.none.or(my_tweets_res).where("? < id", last_res_id_i).where.not(user_id: -1).limit(6).order(id: :asc)

    if res_tweets.present?
      res_tweets.each do |r|
        BotController.talk(r)
        last_res_id_i = r.id
        last_res_id.update(value: last_res_id_i.to_s)
      end
    end

  end

  def self.talk(res_tweet)
    # APIのURL
    url = URI.parse("https://api.a3rt.recruit-tech.co.jp/talk/v1/smalltalk")

    # リクエストパラメータを設定
    post_data = {
      'apikey' => CLIENT_ID,      #APIキー
      'query' => res_tweet.content_ja  #文章の切れ目の文字
    }

    # postリクエスト送信
    res = BotController.post_request(url, post_data, true);

    # エラーの場合、nilを返却
    return nil if res.code != "200"

    # JSON文字列をパースし、要約結果を返却
    result = JSON.parse(res.body)

    return nil if result['status'] != 0

    reply = result['results'][0]['reply']

    tweet = Tweet.new()
    tweet.parent_id = res_tweet.id
    tweet.content = reply
    tweet.user_id = -1
    tweet.create_datetime = Time.current
    tweet.humanity =  0.0
    tweet.text = nil

    tweet.save
  end

  ###
  # POSTリクエストを送信し、そのレスポンスを取得する
  def self.post_request(url, data, use_ssl = true)
    req = Net::HTTP::Post.new(url.request_uri)
    req.set_form_data(data)

    # postリクエスト送信
    Net::HTTP.start(url.host, url.port,
        :use_ssl => use_ssl,
        :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
      http.request(req)
    end
  end
end
