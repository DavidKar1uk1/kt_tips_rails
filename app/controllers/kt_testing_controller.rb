class KtTestingController < ApplicationController
  include AccessToken
  attr_accessor :k2_subscription
  #protect_from_forgery except: [ :receive, :subscribe, :stk_result, :pay_result ]
  # POST /parse
  def receive
    k2_test = K2ConnectRuby::K2Services::K2Client.new(@api_key)
    k2_test.parse_request(request)
    K2Authenticator.authenticate(k2_test.hash_body, k2_test.api_secret_key, k2_test.k2_signature)
  end

  # GET /parse
  def receive_parse
  end

  # POST /subscription
  def subscribe
    request_token
    @k2_subscription = K2ConnectRuby::K2Entity::K2Subscribe.new(@access_token)
    #if @k2_subscription.token_request(ENV["CLIENT_ID"], ENV["CLIENT_SECRET"])
    if @k2_subscription
      @k2_subscription.webhook_subscribe(webhook_params)
      @k1_test_token = K2ConnectRuby::K2Services::K2Client.new(@api_key)
      render 'kt_testing/shows/show_subscription', :object => { :k2_subscription => @k2_subscription , :k1_test_token => @k1_test_token }
    end
  end

  # GET /subscription
  def subscription
  end

  # POST /stk_push
  def stk_push
    @k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(@access_token)
    case params[:decision]
    when "receive_stk"
      @k2_stk.receive_mpesa_payments(params)
    when "query_stk"
      @k2_stk.query_resource(params)
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
    @k2_pay = K2ConnectRuby::K2Entity::K2Pay.new(@access_token)
    case params[:decision]
    when "pay_recipients_form"
      @k2_pay.pay_recipients(params)
    when "query_pay_form"
      @k2_pay.query_resource(params)
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
    @k2_transfers = K2ConnectRuby::K2Entity::K2Transfer.new(@access_token)
    case params[:decision]
    when "create_transfer_form"
      @k2_transfers.transfer_funds(transfer_params)
    when "query_transfer_form"
      @k2_transfers.query_resource(params)
    else
      puts "No Other Transfer Option."
    end
    render 'kt_testing/shows/show_transfers'
  end

  # GET /transfers
  def transfers
  end

  private

  def webhook_params
    {
      event_type: params[:event_type],
      url: params[:url],
      scope: params[:scope],
      scope_reference: params[:scope_reference],
    }
  end

  def transfer_params
    {
      destination_reference: params[:destination_reference],
      destination_type: params[:destination_type],
      currency: params[:currency],
      value: params[:value],
      metadata: params[:metadata],
      callback_url: "https://021c-197-248-175-34.ngrok-free.app/payments/transfers/results",
    }
  end

  def add_recipient_params
    {
      type: params[:type],
      first_name: params[:first_name],
      last_name: params[:last_name],
      phone_number: params[:phone_number],
      email: params[:email],
      network: params[:network],
      account_name: params[:account_name],
      account_number: params[:account_number],
      bank_branch_ref: params[:bank_branch_ref],
      settlement_method: params[:settlement_method],
      till_name: params[:till_name],
      till_number: params[:till_number],
      paybill_name: params[:paybill_name],
      paybill_number: params[:paybill_number],
      paybill_account_number: params[:paybill_account_number],
    }
  end

  def create_payment_params
    {
      destination_reference: params[:destination_reference],
      destination_type: params[:destination_type],
      description: params[:description],
      category: params[:category],
      tags: params[:tags],
      currency: params[:currency],
      value: params[:value],
      callback_url: "https://021c-197-248-175-34.ngrok-free.app/payments/pays/results",
      metadata: params[:metadata],
    }
  end
end
