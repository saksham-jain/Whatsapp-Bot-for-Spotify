Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    root 'home#index'
    get '/log_in', to: 'home#log_in'
    get '/auth/spotify', as: 'auth'
    get '/auth/spotify/callback', to: 'home#log_in'
    resources :clients, only: %I(new create)
  namespace :twilio do
      post 'messages', to: 'messages#create'
  end
end
