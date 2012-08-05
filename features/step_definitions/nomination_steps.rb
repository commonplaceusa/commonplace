Given /^a community$/ do
  @community = FactoryGirl.create(:community)
end
Given /^I am on the nominate page$/ do
  page.visit "/#{Community.first.slug}/nominate"
end

Then /^a new nomination should be created$/ do
  CivicHeroNomination.count.should == 1
end
