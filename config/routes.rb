Rails.application.routes.draw do
  resources :kt_tips
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Route for receiving the JSON response and params
  post '/parse', to: 'todo#receive'
  # Route for the Webhook Subscription
  post '/subscription', to: 'todo#subscribe'
end
