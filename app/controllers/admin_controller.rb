class AdminController < ApplicationController

  before_filter :verify_admin
  #stream :only => :overview_no_render

  def verify_admin
    unless current_user.admin
      redirect_to root_url
    end
  end

  def overview
    @days = 7
    date = @days.days.ago
    @start_year = date.strftime("%Y")
    @start_month = date.strftime("%m")
    @start_day = date.strftime("%d")
    @communities = Community.select{|c| c.users.size > 0 and c.households != nil and c.households > 1 and c.core}.sort{|a,b| a.users.size <=> b.users.size}.reverse
    @user_count = ActiveRecord::Base.connection.execute("SELECT COUNT(id) FROM users")[0]['count'].to_i
    @event_count = ActiveRecord::Base.connection.execute("SELECT COUNT(id) FROM events")[0]['count'].to_i
    @group_post_count = ActiveRecord::Base.connection.execute("SELECT COUNT(id) FROM group_posts")[0]['count'].to_i
    @post_count = ActiveRecord::Base.connection.execute("SELECT COUNT(id) FROM posts")[0]['count'].to_i
    @announcement_count = ActiveRecord::Base.connection.execute("SELECT COUNT(id) FROM announcements")[0]['count'].to_i
    #@message_count = ActiveRecord::Base.connection.execute("SELECT COUNT(id) FROM messages")[0]['count'].to_i
    @reply_count = ActiveRecord::Base.connection.execute("SELECT COUNT(id) FROM replies")[0]['count'].to_i

    @messages_count = Message.count
    @messages_and_replies_count = @messages_count + Reply.find_all_by_repliable_type("Message").count

    @completed_registrations = User.where("created_at < updated_at")
    @incomplete_registrations = User.where("created_at >= updated_at")
    @emails_opened_today = 1
    @emails_opened = 1

    #@live_emails = User.find(:all, :conditions => ["receive_events_and_announcements=true"]).count
    @live_emails = User.where("receive_events_and_announcements = true").count
    @disabled_live_emails = User.where("receive_events_and_announcements = false").count

    @daily_digest_emails = User.where("receive_weekly_digest").count
    @disabled_daily_digest_emails = User.where("receive_weekly_digest = false").count


    render :layout => nil
  end

  def overview_no_render
    @days = 7
    date = @days.days.ago
    @start_year = date.strftime("%Y")
    @start_month = date.strftime("%m")
    @start_day = date.strftime("%d")
    @communities = Community.select{|c| c.users.size > 0 and c.households != nil and c.households > 1 and c.core}.sort{|a,b| a.users.size <=> b.users.size}.reverse
    @user_count = ActiveRecord::Base.connection.execute("SELECT COUNT(id) FROM users")[0]['count'].to_i
    @event_count = ActiveRecord::Base.connection.execute("SELECT COUNT(id) FROM events")[0]['count'].to_i
    @group_post_count = ActiveRecord::Base.connection.execute("SELECT COUNT(id) FROM group_posts")[0]['count'].to_i
    @post_count = ActiveRecord::Base.connection.execute("SELECT COUNT(id) FROM posts")[0]['count'].to_i
    @announcement_count = ActiveRecord::Base.connection.execute("SELECT COUNT(id) FROM announcements")[0]['count'].to_i
    #@message_count = ActiveRecord::Base.connection.execute("SELECT COUNT(id) FROM messages")[0]['count'].to_i
    @reply_count = ActiveRecord::Base.connection.execute("SELECT COUNT(id) FROM replies")[0]['count'].to_i

    @completed_registrations = User.where("created_at < updated_at")
    @incomplete_registrations = User.where("created_at >= updated_at")
    @emails_opened_today = 1
    @emails_opened = 1
    render :layout => nil
  end

  def clipboard
    require 'uuid'
    UUID.state_file = false
    uuid = UUID.new
    if params[:registrants].present?
      entries = params[:registrants].split("\n")
      email_addresses_registered = []
      entries.each do |e|
        entry = e.split(';')
        name = entry[0]
        email = entry[1]
        address = entry[2]
        half_user = HalfUser.new(:full_name => name, :email => email, :street_address => address, :community => Community.find(params[:clipboard_community]), :single_access_token => uuid.generate)
        if half_user.save
          email_addresses_registered << email
          Resque.enqueue(ClipboardWelcome, half_user.id)
        end
      end
      flash[:notice] = "Registered #{email_addresses_registered.count} users: #{email_addresses_registered.join(', ')}"
    end
  end

  def show_referrers
    @referred_users = User.all.select{ |u| u.referral_source.present? }.sort{ |a,b| a.community_id <=> b.community_id }.sort{ |a,b,| a.created_at <=> b.created_at }
  end

  def map
  end
end
