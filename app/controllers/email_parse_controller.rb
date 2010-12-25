class EmailParseController < ApplicationController
  
  def EmailParseController.strip(text,to)
    # Strip any replies from the text
    
    # Check for key phrases
    phrases = ['-- \n','--\n','-----Original Message-----','________________________________','From: ','Sent from my ',TMail::Address.parse(to).spec,TMail::Address.parse(to).spec.match(/[A-Za-z0-9]*/)[0]]
    
    index = text.length + 1
    
    phrases.each { |phrase| 
      newIndex = text.index(phrase)
      if newIndex && newIndex < index
        index = newIndex
      end
    }
    
    # Erase everything before the key phrase
    text = text[0,index]
    
    # Find the last \n character in the remaining text and erase everything after it
    
    index = text.rindex("\n")
    if index
      text[0,text.rindex("\n")]
    else
      text
    end
  end
  
  def parse
    user = User.find_by_email(TMail::Address.parse(params[:from]).spec)
    post = Post.find_by_long_id(TMail::Address.parse(params[:to]).spec.match(/[A-Za-z0-9]*/)[0])
    if user && post
      text = EmailParseController.strip(params[:text],params[:to])
      
      Reply.create(:body => text,
                   :repliable => post,
                   :user => user)
    end
    
    render :nothing => true
  end

end
