class CommunitiesController < ApplicationController
  before_filter :set_default_items
  before_filter :current_community
  before_filter :authorize_current_community

  layout :community_layout
  
  
  def show
    @items = current_user.wire
  end

  protected
  
  def community_layout
    current_user_session ? 'communities' : 'signup'
  end

  def set_default_items
    @items = current_user_session ? current_user.wire : current_user.wire.take(3)
  end

end
