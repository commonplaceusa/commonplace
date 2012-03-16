class API
  class Stats < Authorized
  
    before do
      halt [401, "unauthorized"] unless current_user.admin
    end
    
    get "/" do
      # Return global statistics aggregate
      if StatisticsAggregator.statistics_available?
        stats_by_community = {}
        stats_by_community["global"] = StatisticsAggregator.generate_hashed_statistics_globally
        Community.all.select { |c| c.core }.each do |community|
          stats_by_community[community.slug] = StatisticsAggregator.generate_hashed_statistics_for_community(community)
        end
        serialize stats_by_community
      else
        serialize({ :error => "stats locked" })
      end
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
          :commonplace_account_id => request_body['commonplace_account_id'],
          :community_id => request_body['community_id']
      ).id.to_s
    end

    put "/update_session" do
      serialize SiteVisit.create(
          :original_visit_id => request_body['id'],
          :ip_address => request_body['ip_address'],
          :path => request_body['path'],
          :commonplace_account_id => request_body['commonplace_account_id'],
          :community_id => request_body['community_id']
      ).id.to_s
    end

    put "/create_email" do
      sent_email = SentEmail.create(
        :recipient_email => request_body['recipient_email'],
        :tag_list => request_body['tag_list'],
        :status => :sent,
        :originating_community_id => request_body['originating_community_id'],
        :main_tag => request_body['tag']
      )
      sent_email.id.to_s
    end

    get "/email_opened/:id" do |id|
      begin
        sent_email = SentEmail.find(id)
        sent_email.status = :opened
        sent_email.updated_at = DateTime.now
        sent_email.save
      rescue
      end
    end
  end
end
