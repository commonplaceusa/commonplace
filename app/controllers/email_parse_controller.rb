class EmailParseController < ApplicationController
  
  protect_from_forgery :only => []
  
  before_filter :validate_email
  
  def validate_email
    params[:envelope][:from].present? && !params[:envelope][:from].include?("<>") && !params[:envelope][:from].include?("< >")
  end
  
  def messages
    user = User.find_by_email(TMail::Address.parse(params[:from]).spec)
    post = Message.find_by_long_id(TMail::Address.parse(params[:to]).spec.match(/[A-Za-z0-9]*/)[0])
    if user && post
      text = EmailParseController.strip_email_body(params[:text])
      
      reply = Reply.create(:body => text,
                   :repliable => post,
                   :user => user)
      NotificationsMailer.deliver_message_reply(reply.id)
    end
    
    render :nothing => true
  end
  
  def unpublished
    @user = User.find_by_email(TMail::Address.parse(params[:from]).spec)
    if @user
      # lists my unpublished posts
      @posts = @user.posts.reject {|k,v| k.published == true}
      if @posts.count >= 1
        NotificationsMailer.deliver_unpublished_posts_report
      end
    end
  end
  
  def posts_new
    user = User.find_by_email(TMail::Address.parse(params[:from]).spec)
    if user
      p = Post.create!(:body => params[:text], :user => user, :subject => params[:subject], :community => user.community, :published => false)
      NotificationsMailer.deliver_neighborhood_post_confirmation(user.neighborhood.id,p.id)
    else
      NotificationsMailer.deliver_neighborhood_post_failure
    end
  end
  
  def posts
    user = User.find_by_email(TMail::Address.parse(params[:from]).spec)
    post = Post.find_by_long_id(TMail::Address.parse(params[:to]).spec.match(/[A-Za-z0-9]*/)[0])
    if user && post
      text = EmailParseController.strip_email_body(params[:text])
      
      reply = Reply.create(:body => text,
                   :repliable => post,
                   :user => user)
      NotificationsMailer.deliver_post_reply(reply.id)
    end
    
    render :nothing => true
  end
  
  def events
    user = User.find_by_email(TMail::Address.parse(params[:from]).spec)
    post = Event.find_by_long_id(TMail::Address.parse(params[:to]).spec.match(/[A-Za-z0-9]*/)[0])
    if user && post
      text = EmailParseController.strip_email_body(params[:text])
      
      reply = Reply.create(:body => text,
                   :repliable => post,
                   :user => user)
      NotificationsMailer.deliver_event_reply(reply.id)
    end
    
    render :nothing => true
  end
  
  def announcements
    user = User.find_by_email(TMail::Address.parse(params[:from]).spec)
    post = Announcement.find_by_long_id(TMail::Address.parse(params[:to]).spec.match(/[A-Za-z0-9]*/)[0])
    if user && post
      text = EmailParseController.strip_email_body(params[:text])
      
      reply = Reply.create(:body => text,
                   :repliable => post,
                   :user => user)
      NotificationsMailer.deliver_announcement_reply(reply.id)
    end
    
    render :nothing => true
  end


  def self.strip_email_body(text)
    text.split(%r{(^-- \n) # match standard signature
                 |(^--\n) # match non-stantard signature
                 |(^-----Original\ Message-----) # Outlook
                 |(^----- Original\ Message -----) # Outlook
                 |(^________________________________) # Outlook
                 |(-*\ ?Original\ Message\ ?-*) # Generic
                 |(^On.*wrote:) # OS X Mail.app
                 |(^From:\ ) # Outlook and some others
                 |(^Sent\ from) # iPhone, Blackberry
                 }x).first
  end
  


end
