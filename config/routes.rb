
Commonplace::Application.routes.draw do

  # Community specific redirects
  match "/corunna" => redirect { "/owossocorunna" }
  match "/owosso" => redirect { "/owossocorunna" }

  constraints :subdomain => "m" do
    match "/:community" => "registrations#mobile_new"
    match "/registration/profile" => "registrations#mobile_profile"
  end

  resource :registration, :only => [:new, :create] do
    member do
      get :profile, :avatar, :feeds, :groups
      put :add_profile, :crop_avatar, :add_feeds, :add_groups
    end
  end

  resources :feed_registrations, :only => [:new, :create] do
    member do
      get :profile, :avatar, :subscribers
      put :add_profile, :crop_avatar, :invite_subscribers
    end
  end
 
  get "facebook_canvas/index"
  match "/facebook_canvas/" => "facebook_canvas#index"

  # Global routes

  match "/about" => "site#index", :as => :about
  match "/gatekeeper" => "accounts#gatekeeper"

  match 'email_parse/parse' => 'email_parse#parse', :via => :post
  match "/admin/overview" => "admin#overview"
  match "/admin/export_csv" => "admin#export_csv"
  match "/admin/view_messages" => "admin#view_messages"
  match "/admin/:community/export_csv" => "admin#export_csv"
  match "/admin/overview_no_render" => "admin#overview_no_render"
  match "/admin/clipboard" => "admin#clipboard"
  match "/admin/show_referrers" => "admin#show_referrers"
  match "/admin/show_requests" => "admin#show_requests"
  match "/admin/map" => "admin#map"
  match "/admin/download_csv" => "admin#download_csv"

  # Blog and Starter Site routes
  resources :requests, :only => [:new, :create]

  match "/facebook_canvas/" => "facebook_canvas#index"

  resource :user_session

  resources :feeds, :only => [:edit, :update, :destroy] do
    member do
      get :import
      get :profile
      get :delete
      get :edit_owner
      put :update_owner
      get :avatar
      put :crop_avatar
    end
  end

  match "/pages/:id" => "bootstraps#feed"
  
  match "/messages/:id", :to => "bootstraps#inbox"
  match "/inbox", :to => "bootstraps#inbox"
  match "/account", :to => "bootstraps#account", :via => :get
    
  resource :account, :except => :show do
    member do 
      get :avatar, :delete
      put :crop_avatar
    end
  end
  
  # jasmine test routes
  mount TestTrack::Engine => "test" unless Rails.env.production? || Rails.env.staging?

  begin 
    ActiveAdmin.routes(self) 
    devise_for :admin_users, ActiveAdmin::Devise.config
    
    devise_for :users, :controllers => { 
      :sessions => "user_sessions",
      :passwords => "password_resets",
    :omniauth_callbacks => "users_omniauth_callbacks"
    } do
      get '/users/auth/:provider' => 'users_omniauth_callbacks#passthru'
    end
  rescue
    Rails.logger.warn "ActiveAdmin routes not initialized"
    Rails.logger.warn "Devise routes not initialized"
    # ActiveAdmin and Devise try to hit the database on initialization.
    # That fails when Heroku is compiling assets, so we catch the error here.
  end



  authenticated do

    match 'logout' => 'user_sessions#destroy'

    # Invitations
    resource :account do
      member do
        get :facebook_invite
      end
    end
    match "/send_invite", :to => "accounts#send_invite"
    match "/invite", :to => "accounts#facebook_invite", :as => :invites
    match "/good_neighbor_discount", :to => "communities#good_neighbor_discount"
    

    resources :organizer do
      collection do
        get :map, :app
        post :add
      end
    end

    match '/?community=:community', :to => "bootstraps#community"


    resources :password_resets

    root :to => "bootstraps#community"

    match "/groups/:slug", :to => "bootstraps#group"

  end

  scope "/:community" do
    match 'about' => 'site#about'
    match 'privacy' => 'site#privacy', :as => :privacy
    match 'terms' => 'site#terms', :as => :terms
    match 'dmca' => 'site#dmca', :as => :dmca
    match "faq", :to => "communities#faq", :as => :faq, :via => :get
    match "faq", :to => "communities#send_faq", :via => :post
  end
  


  match "/account/make_focp", :to => "accounts#make_focp"
  match "/account/disable_email", :to => "accounts#disable_email"


  # explicitly list paths that we want the main_page js app to handle
  ["/posts(/:id)", "/users(/:id)", "/events(/:id)", "/feeds",
   "/announcements(/:id)", "/group_posts(/:/id)", "/groups(/:id)",
   "/users/:id/messages/new", "/feeds/:id/messages/new", "/new-event",
   "/new-group-post", "/new-announcement", "/new-neighborhood-post"].each do |s|
    match s, :to => "bootstraps#community", :via => :get, :as => :community
  end


  unauthenticated do

    match '/whereami', :to => 'site#whereami'
    
    root :to => "site#index"
    match "/invite", :to => "accounts#facebook_invite"
    match "/:community", :to => "registrations#new", :via => :get, :as => :community_landing

    match "/:community/learn_more", :to => "accounts#learn_more", :via => :get


    resources :password_resets

    match "/:community/registrations", :via => :post, :to => "registrations#create", :as => "create_registration"

    # Invitations
    resource :account do
      member do
        get :facebook_invite
      end
    end
    
    
  end

  match '/:nil_community', :to => "bootstraps#community"
end
