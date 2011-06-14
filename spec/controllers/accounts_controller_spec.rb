require 'spec_helper'

describe AccountsController do
  before :each do
    stub(Community).find_by_slug { mock_model(Community, :name => "test", :slug => "test",  :time_zone => "Eastern Time (US & Canada)") }

  end

  describe "#create" do
    let(:user) { mock_model(User) }
    before :each do 
      stub(UserSession).find.stub!.user { user}
      stub(user).new_record? { true } 
      stub(User).new { user }
    end

    context "when user save is succesful" do
      before(:each) { stub(user).save { true } }
      
      it "redirects to edit new" do
        post :create, :community => "test"
        response.should redirect_to('http://test.host/account/edit_new')
      end

    end

    context "when user save is not successful" do
      before(:each) { 
        stub(user).save { false }
      }

      it "renders new.haml" do
        post :create, :community => "test"
        response.should render_template("new")
      end
    end
    
  end

end
