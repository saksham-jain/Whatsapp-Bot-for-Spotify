Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :twilio do
      post 'messages', to: 'messages#create'
    end
end
