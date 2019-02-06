Rails.application.routes.draw do
  resources :kt_tips
  root "kt_tips#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Route for receiving the JSON response and params
  post '/parse', to: 'kt_tips#receive'
  # Route for the Webhook Subscription
  get '/subscription', to: 'kt_tips#subscription', as: "subscription"
  post '/subscription', to: 'kt_tips#subscribe'
  # Route for the STK Push
  get '/stk_push', to: 'kt_tips#stk', as: "stk"
  post '/stk_push', to: 'kt_tips#stk_push'
end
