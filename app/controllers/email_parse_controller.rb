class EmailParseController < ApplicationController
  def parse
    user = User.find_by_email(TMail::Address.parse(params[:from]).spec)
    post = Post.find(TMail::Address.parse(params[:to]).spec.match(/post-(\d+)/)[1].to_i)
    if user && post
      RAILS_DEFAULT_LOGGER.error("\n Original data: #{params[:text].split('=20').inspect} \n"}
      Reply.create(:body => params[:text].split("=20")[0],
                   :repliable => post,
                   :user => user)
    end
    
    render :nothing => true
  end

end
