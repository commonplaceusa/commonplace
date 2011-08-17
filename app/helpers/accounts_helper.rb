module AccountsHelper
  def college_dorms_for_school(community)
    # HACK
    if community.is_college
      options_for_select(['Select your residence hall', '-----', community.neighborhoods.map(&:name)].flatten, 'Select your residence hall')
    else
      []
    end
  end
end
