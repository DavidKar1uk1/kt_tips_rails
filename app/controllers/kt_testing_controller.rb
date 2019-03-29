class KtTestingController < ApplicationController
  attr_accessor :k2_subscription
  protect_from_forgery except: [ :receive, :subscribe, :stk_result, :pay_result ]
  # POST /parse
  def receive
    k2_test = K2Client.new(ENV["K2_SECRET_KEY"])
    k2_test.parse_request(request)
    K2Authenticator.authenticate(k2_test.hash_body, k2_test.api_secret_key, k2_test.k2_signature)
    # if true
    #   render 'kt_tips/shows/show_webhook', :object => { :k2_response => response, :k2_components => k2_components, :k2_test => k2_test }
    # end
  end

  # GET /parse
  def receive_parse
  end

  # POST /subscription
  def subscribe
    @k2_subscription = K2Subscribe.new(ENV["K2_SECRET_KEY"])
    puts "Hello"
    if @k2_subscription.token_request(ENV["CLIENT_ID"], ENV["CLIENT_SECRET"])
      ENV["ACCESS_TOKEN"] = @k2_subscription.access_token
      @k2_subscription.webhook_subscribe(params[:subscription])
      @k1_test_token = K2Client.new(ENV["K2_SECRET_KEY"])
      render 'kt_testing/shows/show_subscription', :object => { :k2_subscription => @k2_subscription , :k1_test_token => @k1_test_token }
    end
  end

  # GET /subscription
  def subscription
  end

  # POST /stk_push
  def stk_push
    @k2_stk = K2Stk.new(ENV["ACCESS_TOKEN"])
    case params[:decision]
    when "receive_stk"
      @k2_stk.receive_mpesa_payments(params)
    when "query_stk"
      @k2_stk.query_status(params)
    else
      puts "No Other STK Option"
    end
    render 'kt_testing/shows/show_stk'
  end

  # POST /payment_request_result
  def stk_result

  end

  # GET /stk_push
  def stk
  end

  # POST /pay
  def pay_process
    @k2_pay = K2Pay.new(ENV["ACCESS_TOKEN"])
    case params[:decision]
    when "pay_recipients_form"
      @k2_pay.pay_recipients(params)
    when "query_pay_form"
      @k2_pay.query_status(params)
    when "create_pay_form"
      @k2_pay.create_payment(params)
    else
      puts "No Other Pay Option."
    end
    render 'kt_testing/shows/show_pay'
  end

  # POST /payment_result
  def pay_result
  end

  # GET /pay
  def pay
  end

  # POST /transfers
  def transfers_process
    @k2_transfers = K2Transfer.new(ENV["ACCESS_TOKEN"])
    case params[:decision]
    when "verify_account_form"
      @k2_transfers.settlement_account(params)
    when "create_transfer_form"
      @k2_transfers.transfer_funds(params[:target], params)
    when "query_transfer_form"
      @k2_transfers.query_status(params)
    else
      puts "No Other Transfer Option."
    end
    render 'kt_testing/shows/show_transfers'
  end

  # GET /transfers
  def transfers
  end
end
