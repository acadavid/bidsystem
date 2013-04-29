Bidsystem::Application.routes.draw do
  resources :users, :defaults => { :format => 'json' }
  root :to => 'home#index'
end
