require 'subdomain'
Commonplace::Application.routes.draw do

  get "facebook_canvas/index"

  match "/admin/overview" => "admin#overview"

  # Community routes 

  constraints(Subdomain) do

    root :to => "communities#show"
    
    resource :invites

    # Post-like things
    resources :group_posts, :announcements
    resources :posts do
      member do
        post :notify_all
      end
    end
    
    match ":messagable_type/:messagable_id/messages/new" => "messages#new"
    
    match "/facebook_canvas/" => "facebook_canvas#index"

    resources :messages, :only => :create

    resources :events do
      resource :attendance, :only => [:create, :new]
    end

    resources :replies


    # User/Group-like things
    resources :groups, :only => [:index, :show] do
      resource :membership, :only => [:create, :destroy]
    end
    
    resources :users, :only => [:index, :show] do
      resource :met, :only => [:create, :destroy]
    end

    resources :feeds do
      member do
        get :profile
        get :delete
        get :edit_owner
        put :update_owner
      end

      resource :subscription, :only => [:create, :destroy]
      resources :announcements, :controller => 'feeds/announcements'
      resources :events, :controller => 'feeds/events'
      resource :invites, :controller => 'feeds/invites'
    end


    # Account
    resource :inbox, :only => [:get]
    resources :messages do
      collection do
        get :admin_quick_view
      end
    end

    resources :avatars, :only => [:edit, :update]

    resource :account do
      member do 
        get :edit_new, :edit_avatar, :learn_more, :edit_interests, :add_feeds, :add_groups, :delete, :facebook_invite, :profile
        put :update_new, :update_avatar, :update_interests, :settings
        post :subscribe_to_feeds, :subscribe_to_groups, :avatar
      end
    end

  end

  # Global routes

  root :to => "site#index"
  
  match 'about' => 'site#about'
  match 'privacy' => 'site#privacy'
  match 'terms' => 'site#terms'
  match 'dmca' => 'site#dmca'
  match 'logout' => 'user_sessions#destroy'
  match 'login' => 'user_sessions#new'
  match 'faq' => 'site#faq'
  match 'email_parse/parse' => 'email_parse#parse', :via => :post

  resource :user_session

  resources :password_resets


  # Blog and Starter Site routes
  resources :internships
  resources :requests
  match 'interns', :to => "site#interns"

end
