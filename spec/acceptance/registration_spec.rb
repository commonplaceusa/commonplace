require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Registration", %q{
  In order to engage with my community
  As a neighbor
  I want to register for CommonPlace
} do

  background do
    create_community
    visit "/"
  end

  scenario "landing page includes important actions" do
    page.should have_content("Sign in")
    page.should have_selector("form#new_user")
    page.should have_link("Click here to learn more.", :href => "/account/learn_more")
  end

  scenario "register" do
    mock.proxy(User).new(anything).times(any_times) do |u|
      mock(u).place_in_neighborhood.times(any_times) { u.neighborhood = u.community.neighborhoods.first }
      u
     end

    within "form#new_user" do
      fill_in "user[full_name]", :with => "Bill Cosby"
      fill_in "user[email]", :with => "bcosby@example.com"
      fill_in "user[address]", :with => "52 Hangar Way, 02413"
      click_button "Create User"
    end
  
    current_path.should == "/account/edit_new"

    within "form.user" do
      fill_in "user[password]", :with => "super-secret"
      click_button "Update User"
    end

    current_path.should == "/"
  end

  

end
