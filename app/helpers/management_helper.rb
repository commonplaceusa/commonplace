module ManagementHelper

  def management_options_for(user)
    options = { 'Account' => management_path }

    user.managable_organizations.each do |organization|
      options[organization.name] = url_for([:management, organization])
    end

    user.managable_organizations.map(&:events).flatten.each do |event|
      options[event.name] = url_for([:management, event])
    end
    options_for_select(options)
  end

end
