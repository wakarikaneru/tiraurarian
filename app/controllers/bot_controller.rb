class BotController < ApplicationController

  require 'net/http'
  require 'uri'
  require 'json'

  def self.talk_bot
    # つぶやきを選択
    last_res_id = Control.find_or_create_by(key: "bot_last_res_id")
    last_res_id_i = last_res_id.value.to_i

    my_tweets = Tweet.where(user_id: -1)
    my_tweets_res = Tweet.where(parent_id: my_tweets)
    res_tweets = Tweet.none.or(my_tweets_res).where("? < id", last_res_id_i).where.not(user_id: -1).limit(6).order(id: :asc)

    if res_tweets.present?
      res_tweets.each do |r|
        reply = nil
        reply = reply == nil ? BotController.dialogflow_talk(r) : reply
        reply = reply == nil ? BotController.a3rt_talk(r) : reply

        if reply.present?
          BotController.bot_tweet(r.id, reply)
        end

        last_res_id_i = r.id
        last_res_id.update(value: last_res_id_i.to_s)
      end
    end

  end

  def self.dialogflow_talk(res_tweet)

    project_id = "tirauraria"
    session_id = "mysession"
    text = res_tweet.content_ja
    language_code = "ja"

    require "google/cloud/dialogflow"

    session_client = Google::Cloud::Dialogflow.sessions
    session = session_client.session_path project: project_id, session: session_id
    puts "Session path: #{session}"

    query_input = { text: { text: text, language_code: language_code } }
    response = session_client.detect_intent session: session, query_input: query_input

    query_result = response.query_result

    return nil if query_result.intent.display_name == "Default Fallback Intent"
    return nil if query_result.fulfillment_text.blank?

    return query_result.fulfillment_text

  end

  def self.a3rt_talk(res_tweet)

    api_key = ENV["A3RT_API_KEY"]

    # APIのURL
    url = URI.parse("https://api.a3rt.recruit-tech.co.jp/talk/v1/smalltalk")

    # リクエストパラメータを設定
    post_data = {
      'apikey' => api_key,      #APIキー
      'query' => res_tweet.content_ja  #文章の切れ目の文字
    }

    # postリクエスト送信
    res = BotController.post_request(url, post_data, true);

    # エラーの場合、nilを返却
    return nil if res.code != "200"

    # JSON文字列をパースし、要約結果を返却
    result = JSON.parse(res.body)

    return nil if result['status'] != 0

    return result['results'][0]['reply']

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

  def self.bot_tweet(parent_id, content)
    tweet = Tweet.new()
    tweet.parent_id = parent_id
    tweet.content = content
    tweet.user_id = -1
    tweet.create_datetime = Time.current
    tweet.humanity =  0.0
    tweet.text = nil

    tweet.save
  end
end
