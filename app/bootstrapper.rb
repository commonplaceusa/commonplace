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

    def set_account
      @account = env["warden"].user(:user)
    end
  end

  before do
    normalize_domains
  end

  get "login" do
    @failed_login = false
    erb :login
  end

  get "login_failed" do
    @failed_login = true
    erb :login
  end

  get "login_password_reset" do
    @post_password_reset = true
    erb :login
  end

  get "" do
    set_account
    redirect to(@account ? "/#{@account.community.slug}" : "/about")
  end
  
  get "groups/:slug" do
    set_account
    @group = Group.find_by_slug(params[:slug])
    @community = @group.community
    erb :group
  end

  get "mobile" do
    set_account
    erb :mobile
  end

  get ":community/learn_more" do
    set_account
    @community = Community.find_by_slug(params[:community])
    haml :learn_more
  end

  get %r{([\w]+)/register.*} do 
    @community = Community.find_by_slug(params[:captures].first)
    erb :register
  end

  get ":community" do
    set_account
    @community = Community.find_by_slug(params[:community])
    response.set_cookie("commonplace_community_slug", @community.slug)

    return 404 unless @community
    
    erb @account ? :application : :register
  end

  get "pages/:id" do
    set_account
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
    set_account
    erb :organizer_app
  end

  get %r{([\w]+)/.*} do
    set_account
    @community = Community.find_by_slug(params[:captures].first)

    return 404 unless @community
    
    erb @account ? :application : :register
  end


end
