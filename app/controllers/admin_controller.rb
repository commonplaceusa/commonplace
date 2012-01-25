class AdminController < ApplicationController

  before_filter :verify_admin
  def verify_admin
    unless current_user.admin
      redirect_to root_url
    end
  end

  def view_messages
    @messages = Message.find(:all, :order => "id desc", :limit => 50).sort { |x, y| y.created_at <=> x.created_at }
    render :layout => false
  end


  def overview
    @communities = ActiveSupport::JSON.decode(Resque.redis.get "statistics:community")
    @overall_statistics = ActiveSupport::JSON.decode(Resque.redis.get "statistics:overall")
    @historical_statistics = StatisticsAggregator.historical_statistics
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
    send_data StatisticsAggregator.generate_statistics_csv_for_community(Community.find_by_slug(params[:community])), :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=#{slug}.csv"
  end

  def download_csv
    @communities = Community.all
  end

  def show_requests
    @requests = Request.all.sort{ |a,b| a.created_at <=> b.created_at }
  end
  def show_referrers ; end
  def map ; end
end
