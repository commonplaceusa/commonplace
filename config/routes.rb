
Commonplace::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  match("/#{Jammit.package_path}/:package.:extension",
        :to => 'jammit#package', :as => :jammit, :constraints => {
          # A hack to allow extension to include "."
          :extension => /.+/
        })

  get "facebook_canvas/index"
  match "/facebook_canvas/" => "facebook_canvas#index"

  # Global routes

  match 'email_parse/parse' => 'email_parse#parse', :via => :post
  match "/admin/overview" => "admin#overview"
  match "/admin/clipboard" => "admin#clipboard"
  match "/admin/show_referrers" => "admin#show_referrers"

  # Blog and Starter Site routes
  resources :internships, :only => [:new, :create]
  resources :requests, :only => [:new, :create]
  match 'interns', :to => "site#interns"

  scope "/:community" do

    match 'about' => 'site#about'
    match 'privacy' => 'site#privacy', :as => :privacy
    match 'terms' => 'site#terms', :as => :terms
    match 'dmca' => 'site#dmca', :as => :dmca
    match "faq", :to => "site#faq", :as => :faq
  end
  
  match "/facebook_canvas/" => "facebook_canvas#index"
  match 'login' => 'user_sessions#new', :as => :login
  resource :user_session
  constraints LoggedInConstraint.new(false) do

    root :to => "site#index"
    
    match "/:community/learn_more", :to => "accounts#learn_more"

    resources :password_resets

    match "/:community", :to => "accounts#new"
    match "/:community/account", :via => :post, :to => "accounts#create", :as => "create_account"

  end

  resources :feeds, :only => [:new, :create, :edit, :update] do
    member do
      get :import
      get :profile
      get :delete
      get :edit_owner
      put :update_owner
    end
    resource :subscription, :only => [:create, :destroy]
    resource :invites, :controller => 'feeds/invites', :only => [:new, :create]
  end

    
  resource :account do
    member do 
      get :edit_new, :edit_avatar, :edit_interests, :add_feeds, :add_groups, :delete, :facebook_invite, :profile, :crop
      put :update_new, :update_avatar, :update_interests, :settings, :update_crop
      post :subscribe_to_feeds, :subscribe_to_groups, :avatar
    end
  end

  resource :invites

  constraints LoggedInConstraint.new(true) do

    match 'logout' => 'user_sessions#destroy'

    # Community routes 
    
    resources :groups, :only => [] do
      resource :membership, :only => [:create, :destroy]
    end
    
    # Post-like things
    resources :group_posts, :only => [:create]
    
    resources :announcements, :only => [:create]
    
    resources :posts, :only => [:destroy] do
      member do
        post :notify_all
      end
    end

    resources :events, :only => [:create]  

    resources :replies

    resources :avatars, :only => [:edit, :update]
    resource :inbox, :only => [:get]

    resources :messages do
      collection do
        get :admin_quick_view
      end
    end

    
    root :to => "communities#show"
  end

  match "(*backbone_route)", :to => "communities#show", :via => :get, :as => :community
end
