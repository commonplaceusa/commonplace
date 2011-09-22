require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Registration", %q{
  In order to engage with my community
  As a neighbor
  I want to register for CommonPlace
} do

  background do
    @community = community = FactoryGirl.create(:community, :slug => "testing")
    
    neighborhood = FactoryGirl.create(:neighborhood, :community => community, 
                                      :coordinates => Forgery(:latlng).random)

    stub_geocoder("100 Example Way, #{@community.name}", 
                  :latlng => Forgery(:latlng).random(:within => 15, :miles_of => neighborhood.coordinates))
    Capybara.app_host = "http://localhost:#{Capybara.server_port}"

    visit "/#{community.slug}"
  end

  scenario "landing page includes important actions" do
    page.should have_content("Sign in")
    page.should have_selector("form#new_user")
    page.should have_link("Learn more", :href => "/#{@community.slug}/learn_more")
  end

  scenario "register" do

    within "form#new_user" do
      fill_in "user[full_name]", :with => "Bill Cosby"
      fill_in "user[email]", :with => "bcosby@example.com"
      fill_in "user[address]", :with => "100 Example Way"
      click_button "Create User"
    end

    current_path.should == "/registration/profile"
    save_and_open_page

    within "form.add_profile" do
      fill_in "user[password]", :with => "super-secret"

      find("input.update").click
    end

    current_path.should == "/"
  end

end
