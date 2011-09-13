require 'spec_helper'

describe AccountsController do
  include Devise::TestHelpers


  before :each do
    stub(Community).find_by_slug { mock_model(Community, :name => "test", :slug => "test",  :time_zone => "Eastern Time (US & Canada)") }
    stub(User).email { "#{Forgery(:name).last_name@example.com}".downcase }

  end

  describe "#create" do
    before do 
      @user = User.new
      stub(User).new { @user }
    end

    context "when user save is succesful" do
      before { 
        stub(@user).save { true } 
        stub(controller.kickoff).deliver_welcome_email
        post :create
      }
      
      it "redirects to edit new" do
        response.should redirect_to('http://test.host/account/edit_new')
      end

      it "sends a welcome email" do
        controller.kickoff.should have_received.deliver_welcome_email(@user)
      end
    end

    context "when user save is not successful" do
      before { stub(@user).save { false } }

      it "renders new.haml" do
        post :create
        response.should render_template("new")
      end
    end
    
  end

end
