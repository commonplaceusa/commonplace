require 'spec_helper'

describe 'when logged in' do
  before :each do 
    @group = Group.new
    assigns[:group] = @group
  end
      
  it "should display a new group form" do
    render 'groups/new'
    response.should have_tag('form')
  end
end
