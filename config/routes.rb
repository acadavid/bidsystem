Bidsystem::Application.routes.draw do
  resources :auctions, :defaults => { :format => 'json' }
  resources :users, :defaults => { :format => 'json' }
  resources :bids, :only => [:create], :defaults => { :format => 'json' }
  root :to => 'home#index'
end
