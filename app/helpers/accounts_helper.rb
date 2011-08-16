module AccountsHelper
  def college_dorms_for_school(community)
    # HACK
    if community.is_college
      ['Select your residence hall', '-----', community.neighborhoods.map(&:name)].flatten
    else
      []
    end
  end
end
