require 'access_token'
require 'openssl'
require 'active_support/security_utils'

class WebhookSubscriptionsController < ApplicationController
  include AccessToken
  before_action :set_webhook, only: [:show, :query_resource]
  #before_action :set_subscriber, only: [:subscribe, :query_resource]
  include AccessToken
  # Landing Page
  # GET /webhooks
  def index
    @webhooks = WebhookSubscription.all
  end

  def show;  end

  def new
    @webhook = WebhookSubscription.new
  end

  # POST /webhooks/subscription
  def subscribe
    set_subscriber
    if @k2_subscription
      @k2_subscription.webhook_subscribe(webhook_params, ENV["K2_SECRET_KEY"])
      @sub_test_token = K2Client.new(ENV["K2_SECRET_KEY"])
    end
  end

  def create
    subscribe
    @webhook = WebhookSubscription.create(subscribe_params)
    respond_to do |format|
      if @webhook.save
        format.html { redirect_to @webhook, notice: 'Webhook was successfully created.' }
        format.json { render :show, status: :created, location: @webhook }
      else
        format.html { render :new }
        format.json { render json: @webhook.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST
  def query_resource
    set_subscriber
    @k2_subscription.query_resource_url(@webhook.location_url)
    @webhook.response = @k2_subscription.k2_response_body
    respond_to do |format|
      if @webhook.save
        @webhook.reload
        format.html { redirect_to @webhook, notice: 'Webhook was successfully Queried.' }
        format.json { render :show, status: :created, location: @webhook }
      else
        format.html { render :new }
        format.json { render json: @webhook.errors, status: :unprocessable_entity }
      end
    end
  end

  # Process Request
  def process_webhook
    webhook_test = K2Client.new(ENV["K2_SECRET_KEY"])
    webhook_test.parse_request(request)
    test_obj = K2ProcessWebhook.process(webhook_test.hash_body)
    puts "The Webhook ID:\t\t#{test_obj.id}"
    response = K2ProcessWebhook.return_obj_hash(test_obj)
    unless test_obj.id.nil?
      respond_to do |format|
        format.json { render json: response }
      end
    end
  end

  private

  def set_webhook
    @webhook = WebhookSubscription.find(params[:id])
  end

  def set_subscriber
    request_token
    @k2_subscription = K2Subscribe.new(ENV["ACCESS_TOKEN"])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def webhook_params
    #params.require(:webhook).permit(:webhook_secret, :event_type, :location_url, :access_token, :response)
    params.require(:webhook).permit(:subscription).to_hash.merge({ url: webhook_result_url, scope: 'Till', scope_reference: 5555 } )
  end

  def subscribe_params
    { secret: ENV["K2_SECRET_KEY"], event: @k2_subscription.event_type, location_url: @k2_subscription.location_url, access_token: ENV["ACCESS_TOKEN"], result: @k2_subscription.k2_response_body }
  end

end