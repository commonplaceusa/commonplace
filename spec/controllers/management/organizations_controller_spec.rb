
require 'spec_helper'

describe Management::OrganizationsController do

  it "should respond to show" do
    stub(Organization).find
    get :show
    response.should render_template(:show)
  end

  it "should respond to edit" do
    stub(Organization).find
    get :edit
    response.should render_template(:edit)
  end

  

end
