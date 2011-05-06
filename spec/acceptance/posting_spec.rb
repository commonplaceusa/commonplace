require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Create a post", %q{
  In order to find a ladder
  As a CommonPlace neighbor
  I want to ask my neighbors if I can borrow theirs
} do

  background do
    community = Factory(:community, :slug => "testing", :zip_code => "02321")
    neighborhood = Neighborhood.create(:community_id => community.id, :name => "foo", :bounds => [[0,0]])
    user = User.create!(:first_name => "test", :last_name => "dev",
                        :email => "test@example.com", :address => "420 Baker St.",
                        :password => "password", :neighborhood_id => neighborhood.id,
                        :community_id => community.id)

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
