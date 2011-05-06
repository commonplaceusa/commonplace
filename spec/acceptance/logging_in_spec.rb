require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Logging in", %q{
  In order to interact with CommonPlace
  As a registered user
  I want to log in
} do

  background do
    community = Factory(:community, :slug => "testing", :zip_code => "02321")
    neighborhood = Neighborhood.create(:community_id => community.id, :name => "foo", :bounds => [[0,0]])
    user = User.create!(:first_name => "test", :last_name => "dev",
                        :email => "test@example.com", :address => "420 Baker St.",
                        :password => "password", :neighborhood_id => neighborhood.id,
                        :community_id => community.id)
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
