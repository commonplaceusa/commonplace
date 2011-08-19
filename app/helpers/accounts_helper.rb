module AccountsHelper
  def college_dorms_for_school(community)
    # HACK
    if community.is_college
      options_for_select(['Select your residence hall', '-----', community.neighborhoods.map(&:name)].flatten, 'Select your residence hall')
    else
      []
    end
  end

  def community_registration_url(community)
    return "#{root_url}#{community.slug}"
  end
end
