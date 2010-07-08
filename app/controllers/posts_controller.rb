class PostsController < ApplicationController
  before_filter :load_post

  filter_access_to :all
  
  def create
    respond_to do |format|
      if @post.save
        format.html { redirect_to root_url }
        format.json         
      else
        format.json { render 'new' }
      end
    end
  end

  def show
    respond_to do |format|
      format.json
    end
  end

  protected 
  
  def load_post
    @post = if params[:id]
              Post.find(params[:id])
            elsif params[:post]
              Post.new(params[:post].merge(:user => current_user))
            else 
              Post.new(:user => current_user)
            end
  end
    
end
