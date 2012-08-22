def log_out
  visit('/users/sign_out')
end

def log_in
  email = 'testing@man.net'
  password = 'secretpass'
  User.new(:email => email, :password => password, :password_confirmation => password).save!

  visit '/users/sign_in'
  fill_in "user_email", :with=>email
  fill_in "user_password", :with=>password
  click_button "Sign in"
end

def community_home_page
  if Community.count < 1
    Community.create!(:name => "Test", :slug => "test")
  end
  "/#{Community.all.first.slug}"
end

Given /^a default community exists$/ do
  if Community.count < 1
    Community.create!(:name => 'Test', :slug => 'test')
  end
end

Given /^I am on the registration page$/ do
  log_out
  visit community_home_page
end

When /^I click (.*)$/ do |selector|
  find(selector).click
end

Then /^I should see the sign in dropdown$/ do
  find("#user_sign_in").find("#sign_in_form").find("form").visible?
end

Given /^I see the sign in dropdown$/ do
  log_out
  visit community_home_page
  find("#user_sign_in").click
end

When /^I fill in (.*) with (.*)$/ do |field_name, value|
  unless page.has_field?(field_name)
    if page.has_selector?(:css, "input[placeholder=#{field_name}]")
      page.find(:css, "input[placeholder=#{field_name}]").set(value)
    end
  else
    fill_in field_name, :with => value
  end
end

Then /^I should see the main page$/ do

end

When /^I console$/ do
  binding.pry
end

When /^I press "(.*)"$/ do |button_text|
  page.click_button button_text
end

def wait_for_ajax
  page.wait_until(5) do
    page.evaluate_script 'jQuery.active == 0'
  end
end

When /^I wait for AJAX$/ do
  wait_for_ajax
end

Then /^I should see "(.*)"$/ do |text|
  page.should have_content text
end
