Spree::Core::Engine.routes.draw do
  resources :addresses

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :users do
        collection do
          get :addresses
        end
      end
    end
  end

  if Rails.env.test?
    put '/cart', :to => 'orders#update', :as => :put_cart
  end
end