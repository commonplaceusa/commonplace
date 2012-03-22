require 'spec_helper'

feature "Logging in", %q{
  In order to interact with CommonPlace
  As a registered user
  I want to log in
} do

  background do
    community = @community = FactoryGirl.create(:community, :slug => "testing")
    neighborhood = FactoryGirl.create(:neighborhood, :community => community, 
            :coordinates => Forgery(:latlng).random)

    stub_geocoder("100 Example Way, #{community.name}", 
                  :latlng => Forgery(:latlng).random(:within => 15, :miles_of => neighborhood.coordinates))

    FactoryGirl.create(:user, :email => "test@example.com", :password => "password",
                       :neighborhood_id => neighborhood.id, :community_id => community.id,
                       :address => "100 Example Way")
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"
  end


  scenario "logging in from the landing page" do
    #visit "/#{@community.slug}"
    #find("#sign_in_button").click

    #find("form.user").should be_visible

    #within("form.user") do
    #  fill_in "user[email]", :with => "test@example.com"
    #  fill_in "user[password]", :with => "password"
    #  find("input.submit").click
    #end

    #current_path.should == "/"
  end
end
