require 'spec_helper'

describe AccountsController do
  before :each do
    stub(Community).find_by_slug { mock_model(Community, :name => "test", :slug => "test",  :time_zone => "Eastern Time (US & Canada)") }
    request.host = "test.example.com"
  end
  describe "#new" do

    context "given :short is true" do
      it "renders short.haml" do
        get :new, :short => true 
        response.should render_template('short')
      end
      
    end

    context "given :short is false" do
      it "renders new.haml" do
        get :new 
        response.should render_template('new')
      end
    end

  end

  describe "#create" do
    let(:user) { mock_model(User) }
    before :each do 
      stub(UserSession).find.stub!.user { user}
      stub(user).new_record? { true } 
      stub(User).new { user }
    end

    context "when user save is succesful" do
      before(:each) { stub(user).save.yields(true) }
      
      context "and :short is true" do
        it "redirects to edit new" do
          post :create, :short => true
          response.should redirect_to 'http://test.example.com/feeds/new'
        end
      end

      context "and :short is false" do
        it "redirects to edit new" do
          post :create
          response.should redirect_to 'http://test.example.com/account/edit_new'
        end
      end
    end

    context "when user save is not successful" do
      before(:each) { 
        stub(user).save.yields(false) 
      }
      context "and :short is true" do

        it "renders short.haml" do

          post :create, :short => true
          response.should render_template("short") 
        end
      end

      context "and :short is not true" do
        it "renders new.haml" do
          post :create
          response.should render_template("new")
        end
      end
    end
    
  end

  describe "#update_new" do
    let(:user) { mock_model(User) }
    context "when user is saved" do
      before(:each) do 
        stub(user).save.yields(true)
        stub(UserSession).find.stub!.user { user}
        put :update_new
      end
      
      it "redirects to add_feeds" do
        response.should redirect_to "/account/add_feeds"
      end
    end

    context "when user is not saved" do
      before(:each) do
        stub(UserSession).find.stub!.user { user}
        stub(user).save.yields(false)
        put :update_new
      end

      it "renders edit_new" do
        response.should render_template "edit_new"
      end
    end
  end
end
