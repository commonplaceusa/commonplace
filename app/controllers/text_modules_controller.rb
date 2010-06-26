class TextModulesController < ApplicationController

  layout 'profile'
  
  def index
    @group = Group.find(params[:group_id])
    @text_modules = @group.text_modules
  end
  
  def new
    @group = Group.find(params[:group_id])
    @text_module = @group.text_modules.build
  end

  def create
    @group = Group.find(params[:group_id])
    @text_module = @group.text_modules.build(params[:text_module])
    if @text_module.save
      redirect_to group_text_modules_url(@group.becomes(Group))
    else
      render 'new'
    end
  end



end
