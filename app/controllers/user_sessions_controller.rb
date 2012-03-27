class UserSessionsController < Devise::SessionsController
  layout "sign_in"
  before_filter :load_communities

  def load_communities
    @communities = Community.public.sort_by &:name
  end
end
