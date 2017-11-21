Rails.application.routes.draw do
  get 'users/index'

  get 'users/show'

  get 'content_stats/index'

  get 'content_stats/show'

  get 'content_stats/edit'

  get 'content_stats/update'

  get 'feeds/index'

  get 'feeds/show'

  get 'feeds/edit'

  get 'feeds/update'

  get 'expertise_areas/new'

  get 'expertise_areas/create'

  get 'expertise_areas/update'

  get 'expertise_areas/edit'

  get 'expertise_areas/destroy'

  get 'expertise_areas/index'

  get 'expertise_areas/show'

  get 'expertises/new'

  get 'expertises/create'

  get 'expertises/update'

  get 'expertises/edit'

  get 'expertises/destroy'

  get 'expertises/index'

  get 'expertises/show'

  # resources :webhook

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#landing_screen'
  get 'home/carrot_analy'
  get 'home/about_us'
  get 'home/foam_tree'
  get 'home/d3_analy'
  # get 'home/about_us'
  resources :blogposts do
    delete :delete_content
    collection do
      get :get_locations
      post :get_location_code
    end
  end
  resources :microblogs
  resources :feeds

  resources :users do
    collection do
      get :my_timeline
    end
  end

  mount Messenger::Bot::Space => "/webhook"
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
