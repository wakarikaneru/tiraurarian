module TweetsHelper
  include Twitter::TwitterText::Autolink
  include Twitter::TwitterText::Extractor
  require "nokogiri"
  require "open-uri"

  def uri_extract(str)
    require 'uri'
    return URI.extract(str)
  end

  # URL から 動画ID を取得するための正規表現（時刻指定は除去）
  YOUTUBE_ID_REGEX = %r{\A(?:http(?:s)?://)?(?:www\.)?(?:m\.)?(?:youtu\.be/|youtube\.com/(?:(?:watch)?\?(?:.*&)?v(?:i)?=|(?:embed|v|vi|user)/))([^?&"'>]+)(&t=.*)?\z}

  def embed_youtube(url)
    # YouTube の動画である場合は 埋め込み用URL を戻り値とする
    # そうでない場合は nil を返す
    youtube_id_match = YOUTUBE_ID_REGEX.match(url)
    if youtube_id_match
      "https://www.youtube.com/embed/#{youtube_id_match[1]}"
    end
  end
end
