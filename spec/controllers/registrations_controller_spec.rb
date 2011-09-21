require 'spec_helper'

describe RegistrationsController do
  include Devise::TestHelpers


  before :each do
    stub(Community).find_by_slug { mock_model(Community, :name => "test", :slug => "test",  :time_zone => "Eastern Time (US & Canada)") }
    stub(User).email { "#{Forgery(:name).last_name@example.com}".downcase }

  end

  describe "#create" do
    before do 
      @registration = Registration.new(User.new)
      stub(Registration).new { @registration }
    end

    context "when registration save is succesful" do
      before { 
        stub(@registration).save { true } 
        stub(controller.kickoff).deliver_welcome_email
        post :create
      }
      
      it "redirects to edit new" do
        response.should redirect_to('http://test.host/registration/profile')
      end

      it "sends a welcome email" do
        controller.kickoff.should have_received.deliver_welcome_email(@registration.user)
      end
    end

    context "when user save is not successful" do
      before { stub(@registration).save { false } }

      it "renders new.haml" do
        post :create
        response.should render_template("new")
      end
    end
    
  end

end
