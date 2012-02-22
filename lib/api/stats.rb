class API
  class Stats < Base
    get "/" do
      # Return global statistics aggregate
      stats_by_community = {}
      stats_by_community["global"] = StatisticsAggregator.generate_hashed_statistics_globally
      Community.all.select { |c| c.core }.each do |community|
        stats_by_community[community.slug] = StatisticsAggregator.generate_hashed_statistics_for_community(community)
      end
      serialize stats_by_community
    end

    get "/days" do
      serialize StatisticsAggregator::STATISTIC_DAYS
    end

    get "/community/:id" do |id|
      community = Community.find(id)
      # Return community statistics aggregate
      serialize StatisticsAggregator.generate_hashed_statistics_for_community(community)
    end

    post "/create_session" do
      serialize SiteVisit.create(
          :ip_address => request_body['ip_address'],
          :path => request_body['path'],
          :commonplace_account_id => request_body['commonplace_account_id']
      ).id.to_s
    end

    put "/update_session" do
      serialize SiteVisit.create(
          :original_visit_id => request_body['id'],
          :ip_address => request_body['ip_address'],
          :path => request_body['path'],
          :commonplace_account_id => request_body['commonplace_account_id']
      ).id.to_s
    end
  end
end
