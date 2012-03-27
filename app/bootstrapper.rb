class Bootstrapper < Sinatra::Base

  set :views, Rails.root.join("app", "bootstrapper")

  helpers do
    # Redirect various in-use domains to https://www.ourcommonplace.com/:community
    def normalize_domains
      return unless Rails.env.production?
      return if request.host == "commonplace.herokuapp.com"
      case request.host
        
      when %r{^www\.ourcommonplace\.com$}
        return
        
      when %r{^assets\.}
        return
        
      when %r{^ourcommonplace\.com$}
        redirect "https://www.ourcommonplace.com#{request.path}"
        return
        
      when %r{^(?:www\.)?([a-zA-Z]+)\.ourcommonplace\.com$}
        if request.path == "/" || request.path == ""
          redirect "https://www.ourcommonplace.com/#{$1}"
        else
          redirect "https://www.ourcommonplace.com#{request.path}"
        end
        
      when %r{^(?:www\.)?commonplaceusa.com$}
        case request.path
        when %r{^/$}
          redirect "https://www.ourcommonplace.com/about"
        else
          redirect "https://www.ourcommonplace.com#{request.path}"
        end
      end
    end
  end

  before do
    normalize_domains
    @account = env["warden"].user(:user)
  end

  get "" do
    redirect to(@account ? "/#{@account.community.slug}" : "/about")
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

  get ":community/sign_in" do
    @community = Community.find_by_slug(params[:captures].first)
    erb :application
  end

  get %r{([\w]+)/.*} do
    @community = Community.find_by_slug(params[:captures].first)

    return 404 unless @community
    
    erb @account ? :application : :register
  end


end
