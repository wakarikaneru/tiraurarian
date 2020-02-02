module TweetsHelper
  include Twitter::TwitterText::Autolink
  include Twitter::TwitterText::Extractor


  def omit_word(text)
    text.gsub!(/(.)\1+{14,}/, "\\1…\\1")
    text
  end

end
