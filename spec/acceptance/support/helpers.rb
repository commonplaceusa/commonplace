module Helpers

  def stub_geocoder(address, options)
    stub(Geocoder).search(address) {
      [OpenStruct.new(:coordinates => options[:latlng],
                      :latitude => options[:latlng].first,
                      :longitude => options[:latlng].last)]
    }
  end

  def login_as(user)
    visit '/'
    within("form.user_session") do
      fill_in "user_session[email]", :with => "test@example.com"
      fill_in "user_session[password]", :with => "password"
      find("#user_session_submit").click
    end
  end

end

RSpec.configure { |c| c.include Helpers, :type => :request }

