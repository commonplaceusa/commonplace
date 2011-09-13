class EmailParseController < ApplicationController
  
  protect_from_forgery :only => []
  before_filter :check_user, :filter_out_of_office

  def parse
    case to
      
    when /reply\+([a-zA-Z_0-9]+)/
      if reply = Reply.create(:body => body_text, :repliable => Repliable.find($1), :user => user)
        kickoff.deliver_reply(reply)
      end
    when 'notifications'
      logger.info(<<END
Email to notifications@ourcommonplace.com
subject #{subject}
body: #{body}
from: #{from}
END
)
    else

      if to.downcase == user.community.slug.downcase
        if post = Post.create(:body => body_text, :user => user, :subject => params[:subject], :community => user.community)
        
          kickoff.deliver_post_confirmation(post) 
          kickoff.deliver_post(post)
        end
        
      elsif feed = user.community.feeds.find_by_slug(to)
        if feed.user_id == user.id
          announcement = Announcement.create(:body => body_text, :owner => feed, :subject => params[:subject], :community => feed.community)
          kickoff.deliver_announcement(announcement) if announcement
          kickoff.deliver_announcement_confirmation(announcement) if announcement
        else
          kickoff.deliver_feed_permission_warning(user, feed)
        end

      else
        kickoff.deliver_unknown_address_warning(user)
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
                 |(On.*wrote:) # OS X Mail.app
                 |(From:\ ) # Outlook and some others
                 |(Sent\ from) # iPhone, Blackberry
                 |(In\ a\ message\ dated.*,)
                 }x).first
  end
  
  protected 

  def out_of_office_regexp
    %r{(out\ of\ office)
      |(out\ of\ the\ office)}xi
  end
  def filter_out_of_office
    if params['stripped-text'].match(out_of_office_regexp)
      render :nothing => true
      return false
    end
  end
      
  def current_community
    user.try(:community)
  end

  def check_user
    if user.nil?
      kickoff.deliver_unknown_user_warning(from)
      render :nothing => true
      false
    else
      true
    end
  end

  def user
    @user ||= User.find_by_email(from)
  end

  def body_text
    @body_text ||=
      if personalized_filters.has_key?(from)
        personalized_filters[from].call(params['body-html'])
      else
        EmailParseController.strip_email_body(params['stripped-text'])
      end
  end

  def to
    @to ||= Mail::Address.new(params[:recipient]).address.slice(/^[^@]*/)
  end

  def from
    @from ||= Mail::Address.new(params[:from]).address
  end

  def personalized_filters
    {
      "dwayne.patterson@raleighnc.gov" => lambda do |text| 
        text.match(/<div class=Section1>(.*?)<div>/m)[1].
          gsub(/<.*?>/m,"").
          gsub("&nbsp;","").
          gsub("&#8217;", "'").
          gsub(/\n\n\n*/,"\n\n")
      end
    }
      
  end
  
end
