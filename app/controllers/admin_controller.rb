class AdminController < ApplicationController

  before_filter :verify_admin

  def verify_admin
    unless current_user.admin
      redirect_to root_url
    end
  end

  def overview
    @days = 2
    date = @days.days.ago
    @start_year = date.strftime("%Y")
    @start_month = date.strftime("%m")
    @start_day = date.strftime("%d")
    @communities = Community.all.select{|c| c.users.count > 0 and c.households != nil and c.households > 1 and c.core}.sort{|a,b| a.users.count <=> b.users.count}.reverse
    @users = User.all
    @events = Event.all
    @group_posts = GroupPost.all
    @posts = Post.all
    @announcements = Announcement.all
    @messages = Message.all
    @replies = Reply.all

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


end
