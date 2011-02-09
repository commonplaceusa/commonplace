require 'spec_helper'

describe AccountsController do
  before(:each) { current_community }

  describe "#new" do

    context "given :short is true" do
      before(:each) { get :new, :short => true }

      it "renders short.haml" do
        response.should render_template('short')
      end
      
    end

    context "given :short is false" do
      before(:each) { get :new }

      it "renders new.haml" do
        response.should render_template('new')
      end
    end

  end

  describe "#create" do
    let(:user) { mock_model(User) }
    before :each do 
      user
      stub(current_user).new_record? { true } 
      stub(User).new { user }
    end

    context "when user save is succesful" do
      before(:each) { stub(user).save.yields(true) }
      
      context "and :short is true" do
        it "redirects to edit new" do
          post :create, :short => true
          response.should redirect_to 'http://test.host/feeds/new'
        end
      end

      context "and :short is false" do
        it "redirects to edit new" do
          post :create
          response.should redirect_to 'http://test.host/account/edit_new'
        end
      end
    end

    context "when user save is not successful" do
      before(:each) { stub(user).save.yields(false) }
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
    
    context "when user is saved" do
      before(:each) do 
        stub(current_user).save.yields(true)
        put :update_new
      end
      
      it "redirects to root" do
        response.should redirect_to "/"
      end
    end

    context "when user is not saved" do
      before(:each) do
        stub(current_user).save.yields(false)
        put :update_new
      end

      it "renders edit_new" do
        response.should render_template "edit_new"
      end
    end
  end
end
