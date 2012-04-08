require Rails.root.join("app", "bootstrapper.rb")
require Rails.root.join("app", "administration.rb")
Commonplace::Application.routes.draw do


  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :admin_users

  # Community specific redirects
  match "/corunna" => redirect("/owossocorunna")
  match "/owosso" => redirect("/owossocorunna")


  resources :feed_registrations, :only => [:new, :create] do
    member do
      get :profile, :avatar, :subscribers
      put :add_profile, :crop_avatar, :invite_subscribers
    end
  end
 
  get "facebook_canvas/index"
  match "/facebook_canvas/" => "facebook_canvas#index"

  # Global routes


  match "/gatekeeper" => "accounts#gatekeeper"

  match 'email_parse/parse' => 'email_parse#parse', :via => :post

  # Blog and Starter Site routes
  resources :requests, :only => [:new, :create]

  match "/facebook_canvas/" => "facebook_canvas#index"

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

    
  resource :account, :except => :show do
    member do 
      get :avatar, :delete
      put :crop_avatar
    end
  end
  
  begin 
    devise_for :users, :controllers => { 
      :passwords => "password_resets",
      :omniauth_callbacks => "users_omniauth_callbacks"
    } do
      get '/users/auth/:provider' => 'users_omniauth_callbacks#passthru'
    end
  rescue
    Rails.logger.warn "Devise routes not initialized"
    # ActiveAdmin and Devise try to hit the database on initialization.
    # That fails when Heroku is compiling assets, so we catch the error here.
  end



  authenticated do


    resources :password_resets


  end

  scope "/:community" do
    match 'privacy' => 'site#privacy', :as => :privacy
    match 'terms' => 'site#terms', :as => :terms
    match 'dmca' => 'site#dmca', :as => :dmca
  end

  unauthenticated do

    resources :password_resets

  end

  mount API => "/api"
  mount Administration => "/admin"
  mount Bootstrapper => ""


end
