require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Logging in", %q{
  In order to interact with CommonPlace
  As a registered user
  I want to log in
} do

  background do
    community = Factory :community, :slug => "testing"
    neighborhood = Factory(:neighborhood, :community => community, 
            :coordinates => Forgery(:latlng).random)

    stub_geocoder("100 Example Way", 
                  :latlng => Forgery(:latlng).random(:within => 15, :miles_of => neighborhood.coordinates))

    Factory(:user, :email => "test@example.com", :password => "password",
            :neighborhood => neighborhood, :community => community,
            :address => "100 Example Way")
    
    Capybara.app_host = "http://testing.smackaho.st:#{Capybara.server_port}"
  end


  scenario "logging in from the landing page" do
    visit '/account/new'
    find("#sign_in_button").click

    find("form.user_session").should be_visible

    within("form.user_session") do
      fill_in "user_session[email]", :with => "test@example.com"
      fill_in "user_session[password]", :with => "password"
      find("#user_session_submit").click
    end

    current_path.should == "/"
    
  end
end
