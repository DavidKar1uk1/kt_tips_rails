require 'k2-connect-ruby'

class KtTipsController < ApplicationController
  attr_accessor :k2_subscription
  before_action :set_kt_tip, only: [:show, :edit, :update, :destroy]
  # skip_before_action :verify_authenticity_token, :only => [:receive, :subscribe, ]
  protect_from_forgery except: [ :receive, :subscribe, :stk_result, :pay_result ]

  # POST /parse
  def receive
    k2_test = K2ConnectRuby::K2Client.new(ENV["K2_SECRET_KEY"])
    k2_test.parse_request(request)
    k2_truth_value = K2ConnectRuby::K2Authenticator.new.authenticate?(k2_test.hash_body, k2_test.api_secret_key, k2_test.k2_signature)
    k2_components = K2ConnectRuby::K2SplitRequest.new(k2_truth_value)
    k2_components.judge_truth(k2_test.hash_body)
    # if true
    #   render 'kt_tips/shows/show_webhook', :object => { :k2_response => response, :k2_components => k2_components, :k2_test => k2_test }
    # end
  end

  # GET /parse
  def receive_parse
  end

  # POST /subscription
  def subscribe
    @k2_subscription = K2Subscribe.new("buygoods_transaction_received")
    if @k2_subscription.token_request(ENV["CLIENT_ID"], ENV["CLIENT_SECRET"])
      ENV["ACCESS_TOKEN"] = @k2_subscription.subscriber_access_token
      @k2_subscription.webhook_subscribe
      @k1_test_token = K2ConnectRuby::K2Client.new(ENV["K2_SECRET_KEY"])
      render 'kt_tips/shows/show_subscription', :object => { :k2_subscription => @k2_subscription , :k1_test_token => @k1_test_token }
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
      @k2_stk.mpesa_receive_payments(params)
    when "query_stk"
      @k2_stk.mpesa_query_payments(params[:stk_id])
    else
      puts "No Other STK Option"
    end
    render 'kt_tips/shows/show_stk'
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
      @k2_pay.query_pay(params[:payment_id])
    when "create_pay_form"
      @k2_pay.pay_create(params)
    else
      puts "No Other Pay Option."
    end
    render 'kt_tips/shows/show_pay'
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
      @k2_transfers.transfer_funds("#{params[:target]}", params)
    when "query_transfer_form"
      @k2_transfers.query_transfer("#{params[:transfer_id]}")
    else
      puts "No Other Transfer Option."
    end
    render 'kt_tips/shows/show_transfers'
  end

  # GET /transfers
  def transfers
  end

  # GET /kt_tips
  # GET /kt_tips.json
  def index
    @kt_tips = KtTip.all
  end

  # GET /kt_tips/1
  # GET /kt_tips/1.json
  def show
  end

  # GET /kt_tips/new
  def new
    @kt_tip = KtTip.new
  end

  # GET /kt_tips/1/edit
  def edit
  end

  # POST /kt_tips
  # POST /kt_tips.json
  def create
    @kt_tip = KtTip.new(kt_tip_params)

    respond_to do |format|
      if @kt_tip.save
        format.html { redirect_to @kt_tip, notice: 'Kt tip was successfully created.' }
        format.json { render :show, status: :created, location: @kt_tip }
      else
        format.html { render :new }
        format.json { render json: @kt_tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kt_tips/1
  # PATCH/PUT /kt_tips/1.json
  def update
    respond_to do |format|
      if @kt_tip.update(kt_tip_params)
        format.html { redirect_to @kt_tip, notice: 'Kt tip was successfully updated.' }
        format.json { render :show, status: :ok, location: @kt_tip }
      else
        format.html { render :edit }
        format.json { render json: @kt_tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kt_tips/1
  # DELETE /kt_tips/1.json
  def destroy
    @kt_tip.destroy
    respond_to do |format|
      format.html { redirect_to kt_tips_url, notice: 'Kt tip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kt_tip
      @kt_tip = KtTip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kt_tip_params
      params.require(:kt_tip).permit(:topic, :content, :written_on, :likes)
    end

end
