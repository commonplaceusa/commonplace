require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Create a post", %q{
  In order to find a ladder
  As a CommonPlace neighbor
  I want to ask my neighbors if I can borrow theirs
} do

  background do
    pending "moving away from subdomains"
    
    community = Factory :community, :slug => "testing"
    neighborhood = Factory(:neighborhood, :community => community, 
            :coordinates => Forgery(:latlng).random)
    stub_geocoder("100 Example Way", 
                  :latlng => Forgery(:latlng).random(:within => 15, :miles_of => neighborhood.coordinates))

    user = Factory(:user, :email => "test@example.com", :password => "password",
                   :neighborhood => neighborhood, :community => community,
                   :address => "100 Example Way")

    Capybara.app_host = "http://testing.smackaho.st:#{Capybara.server_port}"

    login_as(user)
  end

  scenario "asking for a ladder" do

    within "#new_post" do
      fill_in "post[subject]", :with => "Anybody have a ladder?"
      fill_in "post[body]", :with => "I need a ladder to paint the outside trim of my house. Anyone have one that I can borrow for a couple days?"
      click_button "Create Post"
    end

    find("#syndicate").should have_content("Anybody have a ladder?")
    find("#syndicate").should have_content("I need a ladder to paint the outside trim of my house.")
    
  end


end
