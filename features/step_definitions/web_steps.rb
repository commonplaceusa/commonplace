# Then I should see a page heading named "Widgets" in the "Main" section
Then /^I should see a page heading named "([^"]*)"(?: in the "([^"]*)" section)?$/ do |text, section|
  with_scope(section,:css_id) do
    page.should have_selector("h1",:text=>text)
  end
end

# Then I should see a link named "Buy this widget" in the "Product Details" section
Then /^I should see a link named "([^"]*)"(?: in the "([^"]*)" section)?$/ do |text, selector|
  with_scope(selector,:css_id) do
    page.should have_link(text)
  end
end
