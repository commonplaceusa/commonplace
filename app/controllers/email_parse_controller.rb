class EmailParseController < ApplicationController
  
  protect_from_forgery :only => []
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
    user = User.find_by_email(TMail::Address.parse(params[:from]).spec)
    if user
    # lists my unpublished posts
      
    end
  end
  
  def posts_new
    user = User.find_by_email(TMail::Address.parse(params[:from]).spec)
    if user
      # Create an unpublished post
      # Published 10 minutes in the future
      # Send confirmation with a link to unpublished posts
    else
      # Send an email explaining that the sender's email was not found, they should sign up, or use the email they signed up with
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
                 |(^________________________________) # Outlook
                 |(^On.*wrote:) # OS X Mail.app
                 |(^From:\ ) # Outlook and some others
                 |(^Sent\ from) # iPhone, Blackberry
                 }x).first
  end
  


end
