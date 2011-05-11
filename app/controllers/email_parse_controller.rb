require 'iconv'

class EmailParseController < ApplicationController
  
  protect_from_forgery :only => []
  before_filter :check_user


  def parse
    case to
      
    when /reply\+([a-zA-Z_0-9]+)/
      if reply = Reply.create(:body => body_text, :repliable => Repliable.find($1), :user => user)
        (reply.repliable.replies.map(&:user) + [reply.repliable.user]).uniq.each do |user|
          if user != reply.user
            logger.info("Enqueue ReplyNotification #{reply.id} #{user.id}")
            Resque.enqueue(ReplyNotification, reply.id, user.id)
          end
        end
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
        post = Post.create(:body => body_text, :user => user, :subject => params[:subject], :community => user.community)

        Resque.enqueue(PostConfirmation, post.id) if post

        user.neighborhood.users.receives_posts_live.each do |u|
          Resque.enqueue(PostNotification, post.id, u.id) if post.user != user
        end
        
      elsif feed = user.community.feeds.find_by_slug(to)
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

  def current_community
    user.try(:community)
  end

  def check_user
    if user.nil?
      Resque.enqueue(UnknownUser, from)
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
      EmailParseController.strip_email_body(case JSON.parse(params[:charsets])['text']
                                            when "UTF-8"
                                              params[:text]
                                            when "iso-8859-1"
                                              Iconv.conv("UTF-8","ISO-8859-1",params[:text])
                                            else
                                              raise "Unknown Encoding: #{params[:charsets]}"
                                            end)
  end

  def to
    @to ||= Mail::Address.new(params[:to]).address.slice(/^[^@]*/)
  end

  def from
    @from ||= Mail::Address.new(params[:from]).address
  end
  
end
