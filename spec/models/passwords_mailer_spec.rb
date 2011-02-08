require 'spec_helper'

describe PasswordsMailer do

  describe "#reset" do

    let(:community) do
      mock_model(Community, 
                 :slug => Forgery(:basic).text,
                 :name => Forgery(:basic).text)
    end

    let(:user) do
      mock_model(User, 
                 :perishable_token => Forgery(:basic).text,
                 :email => Forgery(:internet).email_address,
                 :community => community)
    end

    before :each do
      stub(User).find(user.id) { user }
      @mail = PasswordsMailer.create_reset(user.id)
    end
    
    it "includes a link to edit password url" do
      @mail.body.should include("http://#{user.community.slug}.ourcommonplace.com/password_resets/#{user.perishable_token}")
    end

    it "delivers to the user's email" do
      @mail.to.should include(user.email)
    end
  end

end
