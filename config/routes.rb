HelloApp::Application.routes.draw do

  resources :keywords
  root 'static_pages#home'
  get '/home',  to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/feedback', to: 'static_pages#feedback'
  get '/contact', to: 'static_pages#contact'

  #####################

  resources :reviews, path: 'papers/:paper_id/reviews'
  get    '/reviews/mine' => 'reviews#mine', :as => :user_reviews
  post   'papers/:paper_id/review_opinion' => 'reviews#validate_opinion', :as => :review_opinion

  get   'papers/:paper_id/accept' => 'reviews#accept', :as => :accept_paper
  get   'papers/:paper_id/refuse' => 'reviews#refuse_notif', :as => :refuse_paper_notif
  post   'papers/:paper_id/refuse' => 'reviews#refuse', :as => :refuse_paper
  get   'papers/:paper_id/ask_revision' => 'reviews#ask_revision_notif', :as => :ask_paper_revision_notif
  post   'papers/:paper_id/ask_revision' => 'reviews#ask_revision', :as => :ask_paper_revision

  get  'papers/:paper_id/finished' => 'papers#signal_edition_finished', :as => :signal_edition_finished

  #####################

  resources :people
  get   '/people/:id/edit_password' => 'people#edit_password', :as => :edit_password
  post  '/people/:id/edit_password' => 'people#update_password'
  get   '/people/:id/papers' => 'people#papers', :as => :user_papers

  get   '/signup',  to: 'people#new'
  post  '/signup',  to: 'people#create'
  resources :account_activations#, only: [:edit]

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get   '/people/:id/activate' => 'people#activate', :as => :person_activate

  #####################

  get 'papers/pending', to:  'papers#index_pending'
  get 'papers/all',     to:  'papers#index_all'
  get 'papers/refused', to:  'papers#index_refused'
  resources :papers

  #####################

  resources :categories

  #####################

  get 'reading_lists/public', to: 'reading_lists#index_public'
  resources :reading_lists

  # resources :reading_list_saves
  get 'reading_list_saves/:paper_id',
    to:   'reading_list_saves#save_default',
    :as => :reading_list_save_default
  get 'reading_list_saves/:reading_list_id/:paper_id',
    to:   'reading_list_saves#save',
    :as => :reading_list_save
  get 'reading_list_remove/:reading_list_id/:paper_id',
    to:   'reading_list_saves#remove',
    :as => :reading_list_remove




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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
