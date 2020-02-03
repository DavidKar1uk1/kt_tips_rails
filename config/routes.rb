Rails.application.routes.draw do
  # resources :kt_tips
  resources :webhook_subscriptions, only: [:index, :create, :new, :show]
  scope 'webhook_subscriptions' do
    post '/query/:id', to: "webhook_subscriptions#query_resource", as: :query_webhook
    post '/results', to: "webhook_subscriptions#process_results", as: :webhook_result
  end
  resources :payments, only: [:index]
  namespace :payments do
    resources :stks, only: [:index, :create, :new, :show]
    scope :stks do
      post '/:id/query', to: "stks#query_resource", as: :query_stk
      post '/results', to: "stks#process_results", as: :process_stk
    end

    resources :pays, only: [:index, :create, :new, :show]
    scope :pays do
      post '/:id/query', to: "pays#query_resource", as: :query_pay
      post '/results', to: "pays#process_results", as: :process_pay
    end

    resources :transfers, only: [:index, :create, :new, :show]
    scope :transfers do
      post '/:id/query', to: "transfers#query_resource", as: :query_transfer
      post ' results', to: "transfers#process_results", as: :process_transfer
    end
  end

  root "kt_tips#index"

  # # Route for receiving the JSON response and params
  # post '/parse', to: 'kt_testing#receive'
  # get '/parse', to: 'kt_testing#receive_parse'
  #
  # # Route for the Webhook Subscription
  # #get '/subscription', to: 'kt_testing#subscription', as: "subscription"
  # #post '/subscription', to: 'kt_testing#subscribe'
  #
  # # Route for the STK Push
  # get '/stk_push', to: 'kt_testing#stk', as: "stk"
  # post '/stk_push', to: 'kt_testing#stk_push'
  #
  # # Route for the Transfers
  # get '/transfers', to: 'kt_testing#transfers', as: "transfers"
  # post '/transfers', to: 'kt_testing#transfers_process'
  #
  # # Route for the PAY
  # get '/pay', to: 'kt_testing#pay', as: "pay"
  # post '/pay', to: 'kt_testing#pay_process'
  #
  # # Processing Results
  # post 'webhook_subscription', to: 'processing#webhooks'
  # # Buygoods Received
  # post '/bg_received', to: 'processing#bg_received'
  # # Buygoods Reversed
  # post '/bg_reversed', to: 'processing#bg_reversed'
  # # B2b
  # post '/b2b_transaction', to: 'processing#b2b'
  # # Merchant to Merchant
  # post '/m2m_transaction', to: 'processing#m2m'
  # # Settlement
  # post '/settlement', to: 'processing#settle'
  # # Customer Created
  # post '/customer', to: 'processing#customer'
  # # Stk Payment Successful
  # post '/stk_payment', to: 'processing#stk_payment'
  # # Stk Payment Unsuccessful
  # post '/stk_payment/unsuccessful', to: 'processing#wrong_stk_payment'
  # # Pay Payment
  # post '/pay_payment', to: 'processing#pay_payment'
end
