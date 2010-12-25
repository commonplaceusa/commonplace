class EmailParseController < ApplicationController
  def parse
    user = User.find_by_email(TMail::Address.parse(params[:from]).spec)
    post = Post.find(TMail::Address.parse(params[:to]).spec.match(/post-(\d+)/)[1].to_i)
    if user && post
      Reply.create(:body => params[:text],
                   :repliable => post,
                   :user => user)
    end
    
    render :nothing => true
  end

end
