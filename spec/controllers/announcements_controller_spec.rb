require 'spec_helper'

describe AnnouncementsController do

  it "should set @announcement on show" do
    stub(Announcement).find { :announcement }
    get :show
    assigns[:announcement].should == :announcement
  end
end
