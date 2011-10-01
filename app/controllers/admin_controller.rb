class AdminController < ApplicationController

  before_filter :verify_admin
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
    @live_emails = User.select { |u| u.post_receive_method == 'Live' }.count
    @daily_emails = User.select { |u| u.post_receive_method == 'Daily' }.count
    @disabled_live_emails = User.select { |u| u.post_receive_method == 'Never' }.count

    @daily_digest_emails = User.where("receive_weekly_digest").count
    @disabled_daily_digest_emails = User.where("receive_weekly_digest = false").count


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
          kickoff.deliver_clipboard_welcome(half_user)
        end
      end
      flash[:notice] = "Registered #{email_addresses_registered.count} users: #{email_addresses_registered.join(', ')}"
    end
  end

  def export_csv
    csv = "Date,Users,Posts,Events,Announcements"
    today = DateTime.now
    slug = params[:community]
    community = Community.find_by_slug(slug)
    launch = community.users.sort{ |a,b| a.created_at <=> b.created_at }.first.created_at.to_date
    launch.upto(today).each do |day|
      csv = "#{csv}\n#{day},#{community.users.between(launch.to_datetime,day.to_datetime).count},#{community.posts.between(launch.to_datetime,day.to_datetime).count},#{community.events.between(launch.to_datetime,day.to_datetime).count},#{community.announcements.between(launch.to_datetime,day.to_datetime).count}"
    end

    send_data csv, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=#{slug}.csv"
  end

  def show_referrers ; end
  def map ; end
end
