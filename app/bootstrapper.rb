class Bootstrapper < Sinatra::Base

  set :views, Rails.root.join("app", "bootstrapper")

  before do
    @account = env["warden"].user(:user)
  end

  get "" do
    redirect to(@account ? "/#{@account.community.slug}" : "/users/sign_in")
  end
  
  get "groups/:slug" do
    @group = Group.find_by_slug(params[:slug])
    @community = @group.community
    erb :group
  end

  get "mobile" do
    erb :mobile
  end

  get ":community/learn_more" do
    @community = Community.find_by_slug(params[:community])
    haml :learn_more
  end

  get ":community" do
    @community = Community.find_by_slug(params[:community])

    return 404 unless @community
    
    erb @account ? :application : :register
  end
  
  get %r{([\w]+)/.*} do
    @community = Community.find_by_slug(params[:captures].first)

    return 404 unless @community
    
    erb @account ? :application : :register
  end

  get "pages/:id" do
    @feed = 
      if params[:id].match(/^\d+/) 
        Feed.find_by_id(params[:id])
      else
        Feed.find_by_slug(params[:id])
      end
    @community = @feed.community
    erb :feed
  end

  get "organizer_app/:id" do 
    erb :organizer_app
  end



  

end
