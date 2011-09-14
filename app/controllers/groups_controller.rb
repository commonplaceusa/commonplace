class GroupsController < ApplicationController
  def show
    @group = Group.find(params[:slug])
    render :layout => false
  end
end
