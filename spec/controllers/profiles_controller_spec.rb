require 'spec_helper'

describe ProfilesController do
  before :each do
    login
    @org = mock_model(Organization, :admins => [current_user])
    Organization.stub!(:find).and_return(@org)
  end
  
  it "should render edit" do
    get :edit
    assigns[:organization].should_not be_nil
    response.should render_template(:edit)
  end
  
  it "should redirect to edit on successful update" do 
    @org.stub!(:save).and_return(true)
    put :update
    response.should redirect_to(edit_organizer_profile_url(@org))
  end

  
end
