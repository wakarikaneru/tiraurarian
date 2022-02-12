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
        reply = reply.blank? ? BotController.dialogflow_talk(r) : reply
        reply = reply.blank? ? BotController.openai_talk(r) : reply
        reply = reply.blank? ? BotController.a3rt_talk(r) : reply

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

    return query_result.fulfillment_text

  end

  def self.a3rt_talk(res_tweet)

    api_key = ENV["A3RT_API_KEY"]

    # APIのURL
    url = URI.parse("https://api.a3rt.recruit.co.jp/talk/v1/smalltalk")

    # リクエストパラメータを設定
    form_data = {
      "apikey" => api_key,      #APIキー
      "query" => res_tweet.content_ja  #文章の切れ目の文字
    }

    # postリクエスト送信
    res = BotController.post_request_with_formdata(url, nil, form_data, true);

    # エラーの場合、nilを返却
    return nil if res.code != "200"

    # JSON文字列をパースし、要約結果を返却
    result = JSON.parse(res.body)

    return nil if result['status'] != 0

    return result['results'][0]['reply']

  end

  def self.openai_talk(res_tweet)

    root_tweets = []
    t = res_tweet
    while t.present? && t.parent_id.present? && t.id != 0 do
      root_tweets.push(t)
      t = Tweet.find_by(id: t.parent_id)
    end
    root_tweets.reverse!

    api_key = ENV["OPENAI_API_KEY"]

    # APIのURL
    url = URI.parse("https://api.openai.com/v1/engines/text-davinci-001/completions")

    # ヘッダを設定
    headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer " + api_key
    }

    prompt = "\"チラウラリア\"の管理人代理AIです。丁寧に、ユーモアを交えて、ユーザーからのチャットに返事をします。\n"

    root_tweets.map do |tweet|
      if tweet.user_id == -1
        prompt += "\n" + "AI:" + tweet.content_ja
      else
        prompt += "\n" + "Human:" + tweet.content_ja
      end
    end

    # リクエストパラメータを設定
    post_data = {
      "prompt" => prompt + "Human: #{res_tweet.content}\nAI:",
      "temperature" => 0.9,
      "max_tokens" => 140,
      "top_p" => 1,
      "frequency_penalty" => 0,
      "presence_penalty" => 0.6,
      "stop" => ["Human:", "AI:"]
    }.to_json

    # postリクエスト送信
    res = BotController.post_request(url, headers, post_data, true);

    # エラーの場合、nilを返却
    return nil if res.code != "200"

    # JSON文字列をパースし、結果を返却
    result = JSON.parse(res.body)

    return result['choices'][0]['text']

  end

  ###
  # POSTリクエストを送信し、そのレスポンスを取得する
  def self.post_request(url, headers, data, use_ssl = true)
    req = Net::HTTP::Post.new(url.request_uri)
    req.initialize_http_header(headers)
    req.body = data

    # postリクエスト送信
    Net::HTTP.start(url.host, url.port,
        :use_ssl => use_ssl,
        :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
      http.request(req)
    end
  end

    ###
    # POSTリクエストを送信し、そのレスポンスを取得する
    def self.post_request_with_formdata(url, headers, formdata, use_ssl = true)
      req = Net::HTTP::Post.new(url.request_uri)
      req.initialize_http_header(headers)
      req.set_form_data(formdata)

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
