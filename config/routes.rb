Rails.application.routes.draw do
  resources :kt_tips
  root "kt_tips#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Route for receiving the JSON response and params
  post '/parse', to: 'kt_testing#receive'
  get '/parse', to: 'kt_testing#receive_parse'

  # Route for the Webhook Subscription
  get '/subscription', to: 'kt_testing#subscription', as: "subscription"
  post '/subscription', to: 'kt_testing#subscribe'

  # Route for the STK Push
  get '/stk_push', to: 'kt_testing#stk', as: "stk"
  post '/stk_push', to: 'kt_testing#stk_push'
  # Process STK Payment Request Result
  post '/payment_request_result', to: 'kt_testing#stk_result'

  # Route for the Transfers
  get '/transfers', to: 'kt_testing#transfers', as: "transfers"
  post '/transfers', to: 'kt_testing#transfers_process'

  # Route for the PAY
  get '/pay', to: 'kt_testing#pay', as: "pay"
  post '/pay', to: 'kt_testing#pay_process'
  # Process PAYment Request Result
  post '/payment_result', to: 'kt_testing#pay_result'

  # Payment Results
  # Buygoods Received
  post '/bg_received', to: 'processing#bg_received'
  # Buygoods Reversed
  post '/bg_reversed', to: 'processing#bg_reversed'
  # B2b
  post '/b2b_transaction', to: 'processing#b2b'
  # Merchant to Merchant
  post '/m2m_transaction', to: 'processing#m2m'
  # Settlement
  post '/settlement', to: 'processing#settle'
  # Customer Created
  post '/customer', to: 'processing#customer'
  # Stk Payment Successful
  post '/stk_payment', to: 'processing#stk_payment'
  # Stk Payment Unsuccessful
  post '/stk_payment/unsuccessful', to: 'processing#wrong_stk_payment'
  # Pay Payment
  post '/pay_payment', to: 'processing#pay_payment'
end
