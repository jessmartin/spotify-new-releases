Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/callback', to: 'auth#callback'
  get '/releases', to: 'releases#index'

  root to: 'auth#index'
end
