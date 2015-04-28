Rails.application.routes.draw do

  get 'relationships/create'

  get 'relationships/destroy'

  get 'password_resets/new'

  get 'password_resets/edit'

  root    'static_pages#home'
  get     'help'      =>  'static_pages#help'
  get     'about'     =>  'static_pages#about'
  get     'contact'   =>  'static_pages#contact'
  get     'terms'     =>  'static_pages#terms'
  get     'privacy'   =>  'static_pages#privacy_policy'


  get     'signup'                   =>  'users#new'
  get     'login'                    =>  'sessions#new'
  get     '/auth/:provider/callback' =>  'sessions#create'
  get     '/auth/failure'            =>  'sessions#create'

  post    'login'                    =>  'sessions#create'
  delete  'logout'                   =>  'sessions#destroy'

  get 'tags/:tag', to: 'search#index', as: :tag
  get 'download/:id', to: 'uploads#download', as: :download

  resources :users

  resources :account_activations, only: [:edit, :new, :create]

  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :uploads,             except: [:index]

  resources :relationships,       only: [:create, :destroy]

  resources :upload_moderation,   only: [:edit, :update, :destroy, :index]

  resources :search,              only: [:index]

  resources :user_search,         only: [:index]

  resources :charges

  get "uploads"                      => "search#index"

  get 'donate'                       => 'charges#new'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
