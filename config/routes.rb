ActionController::Routing::Routes.draw do |map|

  map.with_options :conditions => { :subdomain => "admin" } do |admin|
    admin.root :controller => "administration", :action => "show"
    
    admin.resources :addresses, :controller => "administration/addresses"
    admin.resources :feeds, :controller => "administration/feeds"
    admin.resources :communities, :controller => "administration/communities"

  end

  if RAILS_ENV != 'production'
    map.resources :deliveries
  end
  
  map.set_neighborhood("set_neighborhood/:neighborhood_id", 
                       :controller => "application", :action => "set_neighborhood", :method => :post)
  
  map.with_options :conditions => { :subdomain => /[A-Za-z]+/ }, :shallow => true do |community|
    community.resources :avatars, :only => [:edit, :update]
    
    community.root :controller => "communities", :action => "show"

    community.resources :posts
    community.resources :first_posts, :only => [:create,:new]
    
    community.resources :announcements, :collection => {"subscribed" => :get}
    community.resources :subscriptions, :collection => {"recommended" => :get}
    community.resources :replies
    
    community.resources :tags
    
    community.resources :events, :collection => {"your" => :get, "suggested" => :get} do |event|
      event.resource :attendance
      event.resources :referrals
      event.resources :messages, :only => [:create, :new], :requirements => {:messagable => "Event"}
    end
    
    community.resources :users do |user|
      user.resource :met, :only => [:create]
      user.resources :messages, :only => [:create, :new], :requirements => {:messagable => "User"}
    end
    
    community.resources :invites
    
    community.resources :feeds do |feed|
      feed.resource :subscription, :only => [:index, :show, :create, :destroy]
      feed.resource :claim, :member => [:edit_fields]
      feed.resources :announcements, :controller => "feeds/announcements"
      feed.resources :profile_fields, :collection => {"order" => :put}
      feed.resources :messages, :only => [:create, :new], :requirements => {:messagable => "Feed"}
    end

    community.namespace :neighborhood do |neighborhood|
      neighborhood.resources :people, :only => :index
    end

    map.about 'about', :controller => 'site', :action => 'about'
    map.privacy 'privacy', :controller => 'site', :action => 'privacy'
    map.terms 'terms', :controller => 'site', :action => 'terms'
    map.dmca 'dmca', :controller => 'site', :action => 'dmca'
    map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
    map.login 'get-started', :controller => 'user_sessions', :action => 'new'
    
    map.resource :inbox
    map.resources :platform_updates
    map.resource :user_session
    map.resources :password_resets
    
    map.resource :account, :member => { 
      :edit_new => :get, 
      :update_new => :put,
      :edit_avatar => :get,
      :update_avatar => :put,
      :learn_more => :get,
      :edit_interests => :get,
      :update_interests => :put,
      :settings => :put
    }
    map.resources :mets
    map.resource :management, :controller => 'management'

    map.namespace :management do |man|
      man.resources :feeds, :member => [:outreach]do |feed|
        feed.resources :announcements, :controller => 'feeds/announcements'
        feed.resources :events, :controller => 'feeds/events'
        feed.resources :profile_fields, :controller => 'feeds/profile_fields', :collection => {:order => :post}
      end
      man.resources :events, :member => [:replies, :outreach]
      man.resources :invites
      man.resources :email_invites
    end

  end
  
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
