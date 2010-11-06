module TextHelper
  
  def reply_count(item)
    if item.replies.length == 0
      "no replies yet"
    else
      "(#{self.replies.length}) replies"
    end
  end
  
end
