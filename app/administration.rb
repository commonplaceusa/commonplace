class Administration < Sinatra::Base

  set :views, Rails.root.join("app", "administration")

  # Make sure the current user is an admin
  before do
    @account = env['warden'].user(:user)
    redirect "/" unless @account && @account.admin?
  end

  get "/request_stats" do
    haml :request_stats
  end

  post "/request_stats/:type" do |type|
    k = KickOff.new
    k.enqueue_statistics_generation_job(type, @account)
    haml :request_stats_generating
  end

  # Show all the messages passing through CommonPlace
  get "/view_messages" do
    @messages = Message.find(:all, :order => "id desc", :limit => 50).sort { |x, y| y.replied_at <=> x.replied_at }
    haml :view_messages
  end

  get "/view_messages_since/:datestamp" do |datestamp|
    date = Time.at(datestamp.to_i)
    @messages = Message.between(date, DateTime.now.to_time).sort { |x, y| y.replied_at <=> x.replied_at }
    haml :view_messages
  end

  # Export Community data as csvs
  get "/:community/export_csv" do |community|
    response.headers['content_type'] = 'text/csv'
    if community == "global"
      attachment("global.csv")
      response.write StatisticsAggregator.csv_statistics_globally
    else
      attachment "#{community}.csv"
      response.write StatisticsAggregator.generate_statistics_csv_for_community(Community.find_by_slug(params[:community]))
    end
  end

  get "/network_health_stats/:frequency" do |frequency|
    response.headers['content_type'] = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    if frequency == 'weekly'
      attachment('network_health.xlsx')
      response.write StatisticsNetworkHealthCsvGenerator.current_value
    elsif frequency == "monthly"
      attachment('network_health.xlsx')
      response.write StatisticsNetworkHealthCsvGeneratorMonthly.current_value
    end
  end

  # Show referrers that users enter during registration
  get "/show_referrers" do
    haml :show_referrers
  end

  # Show requests to bring CommonPlace to a town (created on the about page)
  get "/show_requests" do
    @requests = Request.all.sort{ |a,b| a.created_at <=> b.created_at }
    haml :show_requests
  end

  # Kickoff a job to generate CSVs
  get "/generate_csvs" do
    Resque.enqueue(StatisticsCsvGenerator)
    200
  end

  # List available CSVs to download, or regenerate them
  get "/download_csv" do
    @communities = Community.all.select { |c| Resque.redis.get("statistics:csv:#{c.slug}").present? }
    @date = Resque.redis.get("statistics:csv:meta:date")
    haml :download_csv
  end

  # Become a user
  #
  # Params: id - the user to become
  get "/become" do
    env['warden'].set_user(User.find(params[:id]), :scope => :user)
    redirect "/"
  end

  get "/:community/civic_hero_nominations" do |slug|
    @community = Community.find_by_slug(slug)
    @nominations = CivicHeroNomination.where(community_id: @community.id)
    haml :civic_hero_nominations
  end

end
