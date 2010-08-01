require 'spec_helper'

describe OrganizerController do
  
  it "should render index when the user has many organizations" do
    login({},{:managable_organizations => [:a,:b,:c]})
    get :index
    response.should render_template(:index)
  end
  
  it "should render edit if the user can edit the org" do
    login
    org = mock_model(Organization, :admins => [current_user])
    Organization.stub!(:find, org)
    get :edit
    response.should render_template(:edit)
  end

end
