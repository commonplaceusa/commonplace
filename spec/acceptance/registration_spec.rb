require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Registration", %q{
  In order to engage with my community
  As a neighbor
  I want to register for CommonPlace
} do

  background do
    @community = community = Factory(:community, :slug => "testing")
    
    neighborhood = Factory(:neighborhood, :community => community, 
                           :coordinates => Forgery(:latlng).random)

    stub_geocoder("100 Example Way", 
                  :latlng => Forgery(:latlng).random(:within => 15, :miles_of => neighborhood.coordinates))

    visit "/#{community.slug}"
  end

  scenario "landing page includes important actions" do
    page.should have_content("Sign in")
    page.should have_selector("form#new_user")
    page.should have_link("Click here to learn more.", :href => "/#{@community.slug}/learn_more")
  end

  scenario "register" do

    within "form#new_user" do
      fill_in "user[full_name]", :with => "Bill Cosby"
      fill_in "user[email]", :with => "bcosby@example.com"
      fill_in "user[address]", :with => "100 Example Way"
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
