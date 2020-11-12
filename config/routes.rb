Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    root 'home#index'
    get '/auth/spotify/callback', to: 'home#logged_in'
  namespace :twilio do
      post 'messages', to: 'messages#create'
    end
end
