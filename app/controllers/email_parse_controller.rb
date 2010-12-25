class EmailParseController < ApplicationController
  def parse
    user = User.find_by_email(params[:from])
    to = params[:to]
    id = to.match(/post-(\d+)/).to_i
    #post = Post.find(params[:to].match(/post-(\d+)/)[1].to_i)
    post = Post.find(id)
    if user && post
      Reply.create(:body => params[:text],
                   :repliable => post,
                   :user => user)
    end
    render :nothing => true
  end

end
