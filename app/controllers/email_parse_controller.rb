class EmailParseController < ApplicationController
  
  protect_from_forgery :only => []

  def feed
    if (feed = Feed.find_by_slug(to)) && feed.user_id == user.id

    end
  ensure
    render :nothing => true
  end

  def reply
    if repliable = Repliable.find(to)

    end
  ensure
    render :nothing => true
  end

  def neighborhood
    if to == "myneighbors"

    end
  ensure
    render :nothing => true
  end

  def parse
    case to
      
    when "neighborhood"
      Post.create(:body => body_text, :user => user, :subject => params[:subject], :community => user.community, :published => false)
      
    when /reply\+([a-zA-Z_0-9]+)/
      Reply.create(:body => body_text, :repliable => Repliable.find($1), :user => user)

    else

      if feed = user.community.feeds.find_by_slug(to)

        if feed.user_id == user.id
          Announcement.create(:body => body_text, :owner => feed, :subject => params[:subject], :community => feed.community)
        end

      else

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
  
  def user
    @user ||= User.find_by_email(TMail::Address.parse(params[:from]).spec)
  end

  def body_text
    @body_text ||= EmailParseController.strip_email_body(params[:text])
  end

  def to
    @to ||= TMail::Address.parse(params[:to]).spec.slice(/^[^@]*/)
  end
end
