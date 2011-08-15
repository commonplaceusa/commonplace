module AccountsHelper
  def college_dorms_for_school(community)
    # HACK
    if community.is_college
      community.neighborhoods.map &:name
    else
      []
    end
  end
end
