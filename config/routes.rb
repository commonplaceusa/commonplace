require 'subdomain'
Commonplace::Application.routes.draw do

  # Global routes

  root :to => "site#index"
  
  match 'about' => 'site#about'
  match 'privacy' => 'site#privacy'
  match 'terms' => 'site#terms'
  match 'dmca' => 'site#dmca'
  match 'logout' => 'user_sessions#destroy'
  match 'login' => 'user_sessions#new'

  resource :user_session

  resources :password_resets


  # Blog and Starter Site routes
  resources :internships
  resources :requests
  match 'interns', :to => "site#interns"


  # Community routes 

  constraints(Subdomain) do

    root :to => "communities#show"
    
    resource :invites

    # Post-like things
    resources :group_posts, :announcements
    resources :posts do
      member do
        put :uplift
      end
    end
    

    resources :events do
      resource :attendance, :only => [:create, :new]
      resource :messages, :only => [:create, :new] # FixME deal with :requirements => {:messageable => "Event"}
    end

    resources :replies


    # User/Group-like things
    resources :groups, :only => [:index, :show]
    
    resources :users, :only => [:index, :show] do
      resource :met, :only => [:create, :destroy]
      resources :messages, :only => [:new, :create]
    end

    resources :feeds do
      member do
        get :import
        get :profile
      end

      resource :subscription, :only => [:create, :destroy]
      resources :announcements, :controller => 'feeds/announcements'
      resources :events, :controller => 'feeds/events'
      resource :invites, :controller => 'feeds/invites'
      
      resources :messages, :only => [:new, :create]
        
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
        get :edit_new, :edit_avatar, :learn_more, :edit_interests, :add_feeds, :add_groups, :delete
        put :update_new, :update_avatar, :update_interests, :settings
        post :subscribe_to_feeds, :subscribe_to_groups, :avatar
      end
    end
  end
end
