# frozen_string_literal: true

class WebhookSubscriptionsController < ApplicationController
  include AccessToken

  TILL_SCOPE_WEBHOOKS = [
    "buygoods_transaction_received",
    "buygoods_transaction_reversed",
    "b2b_transaction_received",
    "card_transaction_received",
    "card_transaction_reversed",
    "card_transaction_voided",
  ]

  before_action :set_webhook, only: [:show, :query_resource]
  before_action :subscribe, only: [:create]

  # Landing Page
  # GET /webhooks
  def index
    @webhooks = WebhookSubscription.all
  end

  def show; end

  def new
    @webhook = WebhookSubscription.new
  end

  # POST /webhooks/subscription
  def create
    @webhook = WebhookSubscription.create(subscribe_params)
    respond_to do |format|
      if @webhook.save
        format.html { redirect_to(@webhook, notice: "Webhook was successfully created.") }
        format.json { render(:show, status: :created, location: @webhook) }
      else
        format.html { render(:new) }
        format.json { render(json: @webhook.errors, status: :unprocessable_entity) }
      end
    end

  rescue => ex
    puts("#{ex.message}\n\t#{ex.backtrace.join("\n\t")}\n\t")
  end

  # POST
  def query_resource
    set_subscriber
    @k2_subscription.query_resource_url(@webhook.location_url)
    @webhook.result = @k2_subscription.k2_response_body
    respond_to do |format|
      if @webhook.save
        @webhook.reload
        format.html { redirect_to(@webhook, notice: "Webhook was successfully Queried.") }
        format.json { render(:show, status: :created, location: @webhook) }
      else
        format.html { render(:new) }
        format.json { render(json: @webhook.errors, status: :unprocessable_entity) }
      end
    end
  end

  # Process Request
  def process_webhook
    request_token
    webhook_test = K2ConnectRuby::K2Services::K2Client.new(@api_key)
    puts("Request: #{request.inspect}")
    webhook_test.parse_request(request)
    puts("Hash body: #{webhook_test.hash_body}")
    puts("K2 Signature: #{webhook_test.k2_signature}")
    test_obj = K2ConnectRuby::K2Utilities::K2ProcessWebhook.process(webhook_test.hash_body, @api_key, webhook_test.k2_signature)
    puts "The Webhook ID:\t\t#{test_obj.id}"
    response = K2ConnectRuby::K2Utilities::K2ProcessWebhook.return_obj_hash(test_obj)
    unless test_obj.id.nil?
      respond_to do |format|
        format.json { render(json: response) }
      end
    end
  end

  private

  def set_webhook
    @webhook = WebhookSubscription.find(params[:id])
  end

  def set_subscriber
    request_token
    @k2_subscription = K2ConnectRuby::K2Entity::K2Subscribe.new(@access_token)
  end

  def subscribe
    set_subscriber
    if @k2_subscription
      @k2_subscription.webhook_subscribe(webhook_params)
      @sub_test_token = K2ConnectRuby::K2Services::K2Client.new(@api_key)
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def webhook_params
    {
      event_type: params[:subscription],
      url: params[:callback_url],
    }.merge(scope_params)
  end

  def scope_params
    if params[:subscription].in?(TILL_SCOPE_WEBHOOKS)
      {
        scope: "till",
        scope_reference: 112233,
      }
    else
      {
        scope: "company",
      }
    end
  end

  def subscribe_params
    { event: params[:subscription], location_url: @k2_subscription.location_url, access_token: @access_token, result: @k2_subscription.k2_response_body }
  end
end
