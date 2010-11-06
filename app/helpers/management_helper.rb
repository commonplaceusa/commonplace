module ManagementHelper

  def management_options_for(user)
    options = { 'Account' => management_path }

    user.managable_feeds.each do |feed|
      options[feed.name] = url_for([:management, feed])
    end

    user.managable_feeds.map(&:events).flatten.each do |event|
      options[event.name] = url_for([:management, event])
    end
    options_for_select(options)
  end

end
