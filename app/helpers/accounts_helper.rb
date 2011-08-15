module AccountsHelper
  def college_dorms_for_school(community)
    # HACK
    if community.slug == "umw"
      ['Alvery/Arrington', 'Willard/Virginia', 'Madison/Ball/Custis', 'Westmoreland', 'Bushnell/Jefferson', 'Marshall/Russell', 'South/Framer', 'UMW Apartments', 'Eagle Landing', 'Off-Campus']
    else
      []
    end
  end
end
