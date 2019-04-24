Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/callback', to: 'auth#callback'

  root to: 'auth#index'
end
