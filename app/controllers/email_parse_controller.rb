class EmailParseController < ApplicationController
  def parse
    user = User.find_by_email(params[:from])
    post = Post.find(params[:to].match(/post-(\d+)/)[1].to_i)
    if user && post
      Reply.create(:body => params[:text],
                   :repliable => post,
                   :user => user)
    end
    render :nothing => true
  end

end
