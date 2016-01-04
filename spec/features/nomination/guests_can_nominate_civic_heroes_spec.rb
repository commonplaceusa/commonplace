require "spec_helper"

feature "Civic hero nomination" do
  it "works" do
    community = FactoryGirl.create(
      :community,
      slug: "test",
    )

    page.visit "/#{Community.first.slug}/nominate"

    page.fill_in "Their Full Name", with: "John Doe"
    page.fill_in "Their Email Address", with: "jdoe@gmail.com"
    page.fill_in "Tell us why you are nominating this person.", with: "Because"
    page.fill_in "Your Full Name", with: "Jason Berlinsky"
    page.fill_in "Your Email Address", with: "jberlinsky@gmail.com"

    page.click_button "Nominate this person"

    expect(page).to have_content "Thanks for Nominating!"
    # expect(CivicHeroNomination.count).to eq 0
  end
end
