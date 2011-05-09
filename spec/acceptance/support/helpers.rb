module Helpers

  def login_as(user)
    visit '/'
    within("form.user_session") do
      fill_in "user_session[email]", :with => "test@example.com"
      fill_in "user_session[password]", :with => "password"
      find("#user_session_submit").click
    end
  end

  def create_community
    community = Factory(:community, :slug => "testing", :zip_code => "02321")
    Neighborhood.create(:community_id => community.id, :name => "foo", :bounds => [[0,0]])
    Capybara.app_host = "http://testing.smackaho.st:#{Capybara.server_port}"
    community
  end


  def create_user(community)
    User.create!(:first_name => "test", :last_name => "dev",
                 :email => "test@example.com", :address => "420 Baker St.",
                 :password => "password", :neighborhood_id => community.neighborhoods.first.id,
                 :community_id => community.id)
    
  end
  


end

RSpec.configure { |c| c.include Helpers, :type => :request }

