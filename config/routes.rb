
Commonplace::Application.routes.draw do

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

  get "facebook_canvas/index"
  match "/facebook_canvas/" => "facebook_canvas#index"

  # Global routes

  match "/about" => "site#index", :as => :about
  match "/gatekeeper" => "accounts#gatekeeper"

  match 'email_parse/parse' => 'email_parse#parse', :via => :post
  match "/admin/overview" => "admin#overview"
  match "/admin/:community/export_csv" => "admin#export_csv"
  match "/admin/overview_no_render" => "admin#overview_no_render"
  match "/admin/clipboard" => "admin#clipboard"
  match "/admin/show_referrers" => "admin#show_referrers"
  match "/admin/map" => "admin#map"

  # Blog and Starter Site routes
  resources :internships, :only => [:new, :create]
  resources :requests, :only => [:new, :create]
  match 'interns', :to => "site#interns"

  match "/facebook_canvas/" => "facebook_canvas#index"

  resource :user_session

  resources :feeds, :only => [:show, :new, :create, :edit, :update, :destroy] do
    member do
      get :import
      get :profile
      get :delete
      get :edit_owner
      put :update_owner
      get :new_profile
      put :create_profile
      get :crop
      put :update_crop
    end
  end

  match "/pages/:id" => "feeds#profile"
    
  resource :account do
    member do 
      get :edit_new, :edit_avatar, :edit_interests, :add_feeds, :add_groups, :delete, :profile, :crop
      put :update_new, :update_avatar, :update_interests, :settings, :update_crop
      post :subscribe_to_feeds, :subscribe_to_groups, :avatar
      get :new_facebook
    end
  end

  resource :invites

  unauthenticated do

    root :to => "site#index"
    
    match "/:community/learn_more", :to => "accounts#learn_more"


    resources :password_resets
    match "/:community", :to => "accounts#new"
    match "/:community/account", :via => :post, :to => "accounts#create", :as => "create_account"

    # Invitations
    resource :account do
      member do
        get :facebook_invite
      end
    end
    
    match "/invite", :to => "accounts#facebook_invite"
  end


  authenticated do

    match 'logout' => 'user_sessions#destroy'

    # Invitations
    resource :account do
      member do
        get :facebook_invite
      end
    end

    match "/invite", :to => "accounts#facebook_invite"

    # Community routes 
    
    match "/:community/good_neighbor_discount", :to => "communities#good_neighbor_discount"
    
    # Post-like things
    resource :inbox, :only => [:get]

    resources :messages do
      collection do
        get :admin_quick_view
      end
    end

    resources :organizer do
      collection do
        get :map
        post :add
      end
    end

    match '/?community=:community', :to => "communities#show"

    match '/:nil_community', :to => "communities#show"

    resources :password_resets

    root :to => "communities#show"

    match "/groups/:slug", :to => "groups#show"

  end



  scope "/:community" do
    match 'about' => 'site#about'
    match 'privacy' => 'site#privacy', :as => :privacy
    match 'terms' => 'site#terms', :as => :terms
    match 'dmca' => 'site#dmca', :as => :dmca
    match "faq", :to => "site#faq", :as => :faq, :via => :get
    match "faq", :to => "site#send_faq", :via => :post
  end
  


  match "/account/make_focp", :to => "accounts#make_focp"
  # explicitly list paths that we want the main_page js app to handle
  ["/posts(/:id)", "/users(/:id)", "/events(/:id)", "/feeds",
   "/announcements(/:id)", "/group_posts(/:/id)", "/groups(/:id)",
   "/users/:id/messages/new"].each do |s|
    match s, :to => "communities#show", :via => :get, :as => :community
  end
end
