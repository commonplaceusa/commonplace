class EmailParseController < ApplicationController
  
  protect_from_forgery :only => []
  before_filter :check_user, :check_envelope

  def parse
    case to
      
    when /neighborhood/i
      post = Post.create(:body => body_text, :user => user, :subject => params[:subject], :community => user.community, :published => false)
      
      Resque.enqueue(PostConfirmation, post.id) if post

    when /reply\+([a-zA-Z_0-9]+)/
      Reply.create(:body => body_text, :repliable => Repliable.find($1), :user => user)

    else

      if feed = user.community.feeds.find_by_slug(to)
        
        if feed.user_id == user.id
          announcement = Announcement.create(:body => body_text, :owner => feed, :subject => params[:subject], :community => feed.community)

          Resque.enqueue(AnnouncementConfirmation, announcement.id) if announcement

        else
          Resque.enqueue(NoFeedPermission, user.id, feed.id)
        end

      else
        Resque.enqueue(UnknownAddress, user.id)
      end
      
    end

  ensure 
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
                 |(^In\ a\ message\ dated.*,)
                 }x).first
  end
  
  protected 

  def check_user
    if user.nil?
      Resque.enqueue(UnknownUser, from)
      render :nothing => true
      false
    else
      true
    end
  end

  def check_envelope
    params[:envelope][:from].present?
  end
  
  def user
    @user ||= User.find_by_email(from)
  end

  def body_text
    @body_text ||= EmailParseController.strip_email_body(params[:text])
  end

  def to
    @to ||= TMail::Address.parse(params[:to]).spec.slice(/^[^@]*/)
  end

  def from
    @from ||= TMail::Address.parse(params[:from]).spec
  end
  
end
