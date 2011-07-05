BitcoinQa::Application.routes.draw do
  devise_for :users

  resources :commits

  root :to => 'commits#index'
end
