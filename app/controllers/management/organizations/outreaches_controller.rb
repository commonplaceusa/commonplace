class Management::Organizations::OutreachesController < ManagementController
  
  def index
    @organization = Organization.find(params[:organization_id])
    @possible_subscribers = User.tagged_with_aliases(@organization.tags.map(&:name), :any => true)
  end

end
