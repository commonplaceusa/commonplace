class MembershipsController < CommunitiesController

  def create
    @group = Group.find params[:group_id]
    current_user.groups << @group
  end
  
  def destroy
    @group = Group.find params[:group_id]
    current_user.groups.delete @group
    current_user.save
    render :create
  end
end
