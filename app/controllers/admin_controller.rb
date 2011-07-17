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

    @completed_registrations = User.where("created_at < updated_at")
    @incomplete_registrations = User.where("created_at >= updated_at")
    @emails_opened_today = 1
    @emails_opened = 1
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
    if params[:registrants].present?
      entries = params[:registrants].split("\n")
      email_addresses_registered = []
      entries.each do |e|
        entry = e.split(';')
        name = entry[0]
        email = entry[1]
        address = entry[2]
        user = User.new(:full_name => name, :email => email, :address => address, :community => Community.find(params[:clipboard_community]))
        if user.save_without_session_maintenance
          email_addresses_registered << email
          Resque.enqueue(ClipboardWelcome, user.id)
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
