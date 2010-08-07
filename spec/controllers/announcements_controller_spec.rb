require 'spec_helper'

describe AnnouncementsController do

  it "should set @announcements on index" do
    get :index
    assigns[:announcements].should_not be_nil
  end

  it "should set up @announcement on show" do
    Announcement.stub!(:find).and_return(mock_model(Announcement))
    get :show
  end
end
