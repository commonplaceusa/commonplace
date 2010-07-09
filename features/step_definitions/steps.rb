
def user
  mock_geocoder
  @user ||= Factory(:user)
end


def login
  user
  visit path_to("the homepage")
  fill_in "Email", :with => user.email
  fill_in "Password", :with => user.password
  click_button "Log in"
end

When /^I submit the "([^\"]*)" form$/ do |id|
  submit_form(id)
end

Given /^I am a registered user$/ do
  user
end

Given /^I am logged in$/ do
  login
end
