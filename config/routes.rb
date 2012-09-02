Urdating::Application.routes.draw do

  get "sms/index"

  resources :profile
  match 'home/phone' => 'home#phone', :as => 'profile_phone'
  match '/phone_update' => 'home#phone_update', :via => [:put]

  resources :authentications

  get "home/index"
  match '/about' => 'home#about'
  match '/terms' => 'home#terms'
  match '/privacy' => 'home#privacy'

  get "home/about"
  get "home/how"

  get "home/contact"
  get "home/confirmation"

  # devise_for :users
  
  match "/send_confirmation" => 'home#send_confirmation'
  match '/auth/:provider/callback' => 'authentications#create'
  match '/profile' => 'profile#index', :as => :profile
  match '/incoming' => 'sms#index'
  match '/sms' => 'sms#index', :via => [:get, :post]
  match '/twilio' => 'sms#index', :via => [:post]
  match '/phone_call' => 'sms#phone_call', :via => [:post]
  


  devise_for :users, :controllers => {:registrations => 'users/registrations', :confirmations => 'users/confirmations'}
  # match 'users/:id' => 'users#show', :as => :user
  resources :users, :only => [:index, :show]
  
  resources :user_steps
  
  root :to => "home#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
