module TweetsHelper

  def to_link(text)
    text.encode!(xml: :text)
    URI.extract(text, ["http", "https"]).uniq.each do |url|
      text.gsub!(url, "<a href=\"#{url}\"target=\"_blank\">#{url}</a>")
    end
    text.scan(/\s#\S+/).each do |tag|
      tagstr = tag.gsub(/ #/, "")
      text.gsub!(tag, " <a href=\"/tweets?mode=tag&tag=#{tagstr}\">##{tagstr}</a>")
    end
    text
  end

  def omit_word(text)
    text.gsub!(/(.)\1+{14,}/, "\\1…\\1")
    text
  end

end
