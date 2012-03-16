
Commonplace::Application.routes.draw do
  mount API => "/api"
  match "/mobile" => "bootstraps#mobile"

  # Community specific redirects
  match "/corunna" => redirect { "/owossocorunna" }
  match "/owosso" => redirect { "/owossocorunna" }
  match "/style_guide" => "bootstraps#style_guide"

  match "/organizer_app/:id" => "bootstraps#organizer_app"

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
  

    
  resource :account, :except => :show do
    member do 
      get :avatar, :delete
      put :crop_avatar
    end
  end
  
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


    resources :password_resets

    root :to => "bootstraps#community"

    match "/groups/:slug", :to => "bootstraps#group"

    match '/:community', :to => "bootstraps#application"

  end

  scope "/:community" do
    match 'about' => 'site#about'
    match 'privacy' => 'site#privacy', :as => :privacy
    match 'terms' => 'site#terms', :as => :terms
    match 'dmca' => 'site#dmca', :as => :dmca
    match 'invite', :to => "bootstraps#application", :as => :invites
    match "faq", :to => "bootstraps#application", :as => :faq, :via => :get
    match "stats", :to => "bootstraps#application", :as => :stats, :via => :get
    match "discount", :to => "bootstraps#application"
    match "tour", :to => "bootstraps#application"
    match "list/:tab", :to => "bootstraps#application"
    match "share/:tab", :to => "bootstraps#application"
    match "message/:type/:id", :to => "bootstraps#application"
    match "show/:type/:id", :to => "bootstraps#application"
    match "inbox", :to => "bootstraps#application"
    match "outbox", :to => "bootstraps#application"
    match "feed_inbox", :to => "bootstraps#application"
    match "account", :to => "bootstraps#application"
    match "find_neighbors", :to => "bootstraps#application"
    match "find_neighbors/callback", :to => "bootstraps#application"
  end


  
  match "/account/make_focp", :to => "accounts#make_focp"
  match "/account/disable_email", :to => "accounts#disable_email"

  unauthenticated do

    root :to => "site#index"
    match "/:community", :to => "bootstraps#registration"
    scope "/:community" do
      match "/new", :to => "bootstraps#registration"
      match "/profile", :to => "bootstraps#registration"
      match "/feeds", :to => "bootstraps#registration"
      match "/groups", :to => "bootstraps#registration"
      match "/crop", :to => "bootstraps#registration"
      match "/facebook", :to => "bootstraps#registration"
      match "/neighbors", :to => "bootstraps#registration"
    end

    match "/:community/learn_more", :to => "accounts#learn_more", :via => :get

    resources :password_resets

  end


end
