class EmailParseController < ApplicationController
  def parse
    user = User.find_by_email(TMail::Address.parse(params[:from]).spec)
    post = Post.find(TMail::Address.parse(params[:to]).spec.match(/post-(\d+)/)[1].to_i)
    if user && post
      #RAILS_DEFAULT_LOGGER.error("\n Original data: #{params[:text].inspect} \n")
      # Strip any replies from the text
      
      text = params[:text]
      
      # Check for key phrases
      phrases = ['-- \n','--\n','-----Original Message-----','________________________________','From: ','Sent from my ',TMail::Address.parse(params[:to]).spec,"#{TMail::Address.parse(params[:to]).spec.match(/post-(\d+)/)[1]}-replies"]
      
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
      
      text = text[0,text.rindex("\n")]
      
      Reply.create(:body => text,
                   :repliable => post,
                   :user => user)
    end
    
    render :nothing => true
  end

end
