module Trackable
  def self.included(base)
    base.extend(InstanceMethods)
  end

  def is_trackable
    include InstanceMethods
  end

  module InstanceMethods
    def is_trackable

    end
    def log_event_to_mixpanel(event, opts = {}, perma_opts = {})
      unless Rails.env.production?
        return
      end

      if session[:mixpanel_opts]
        perma_opts.merge!(session[:mixpanel_opts])
      end

      session[:mixpanel_opts] = perma_opts

      #if (current_user and current_user.super_admin?)
      #  return
      #end

      if current_user
        opts.merge!({})
      end

      opts.merge! perma_opts
      unique_id = fetch_mixpanel_id
      Mixpanel.log_event(event, unique_id, request.remote_ip, opts)
    end

    def log_event_to_kissmetrics
      # TODO: Implement
    end

    def fetch_mixpanel_id
      srand
      user_id = current_user ? current_user.id : session[:user_id]
      @mixpanel_id = session[:mixpanel_id]
      if user_id
        @mixpanel_id = Rails.cache.read("mixpanel_id_for_#{user_id}") || @mixpanel_id
        @mixpanel_id ||= user_id
        Rails.cache.write("mixpanel_id_for_#{user_id}", @mixpanel_id)
      else
        @mixpanel_id ||= rand(10 ** 10).to_i
      end

      session[:mixpanel_id] = @mixpanel_id
    end
  end
end
ActiveRecord::Base.send(:include, Trackable)
# NOTE: This model does not have an associated migration

module TrackableOnCreation
  def self.included(base)
    base.extend(InstanceMethods)
  end
  def track_on_creation
    is_trackable
    before_create :log_creation
    include InstanceMethods
  end

  module InstanceMethods
    def track_on_creation
      is_trackable
      before_create :log_creation
    end
    def log_creation
      # TODO: Stub. Include user info here.
      perma_opts = {}
      opts = {}
      if current_user
        opts['email'] = current_user.email
        opts['name'] = current_user.full_name
        perma_opts['neighborhood'] = current_user.neighborhood.asdas
        opts['receive_events_and_announcements'] = current_user.receive_events_and_announcements
        perma_opts['community'] = current_user.community.name
        perma_opts['referral_source'] = current_user.referral_source
        opts['seen_tour'] = current_user.seen_tour
      end
      if current_community and not current_user
        opts['community'] = current_community.name
      end
      opts['type'] = object_name
      log_event_to_mixpanel("Created Tracked Element", opts, perma_opts)
      log_event_to_mixpanel("Created #{object_name}", {}, perma_opts)
    end

    def object_name
      # Get the name of the object that subclasses TrackedCreation
      # If not available, return 'Undefined Content'
      return self.class.name
      return 'Undefined Content'
    end
  end
end

ActiveRecord::Base.send(:include, TrackableOnCreation)
