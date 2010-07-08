require 'spec_helper'

describe SiteController do

  it "should render community page if logged in" do
    login
    get :index
    response.should render_template(:home)
  end

  it "should render home page if not logged in" do
    get :index
    response.should render_template(:index)
  end

end
