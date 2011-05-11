module TextHelper

  def vowel?(char)
    !!char.match(/[aeiou]/i)
  end
    
  def reply_count(item)
    if item.replies.length == 0
      "no replies yet"
    else
      "(#{self.replies.length}) replies"
    end
  end
  
  def with_article(noun)
    [vowel?(noun.slice(0,1)) ? 'an' : 'a', noun].join(" ")
  end

  def markdown(text)
    BlueCloth.new(text || "").to_html.html_safe
  rescue
    "<p>#{text}</p>".html_safe
  end
end
