class EmailParseController < ApplicationController
  def parse
    from = params[:from]
    user = User.find_by_email(from)
    to = params[:to]
    id = to.match(/post-(\d+)/)[1].to_i
    #post = Post.find(params[:to].match(/post-(\d+)/)[1].to_i)
    post = Post.find(id)
    if user && post
      Reply.create(:body => params[:text],
                   :repliable => post,
                   :user => user)
      RAILS_DEFAULT_LOGGER.error("\n Created reply (or so we think...) \n")
    end
    if !user
      RAILS_DEFAULT_LOGGER.error("\n User does not exist with e-mail #{from} \n")
    end
    if !post
      RAILS_DEFAULT_LOGGER.error("\n Post does not exist with ID #{id} \n")
    end
    
    render :nothing => true
  end

end
