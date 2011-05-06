require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Logging in", %q{
  In order to interact with CommonPlace
  As a registered user
  I want to log in
} do

  background do
    community = create_community
    create_user(community)
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
