require 'access_token'
class WebhooksController < ApplicationController
  before_action :set_webhook, only: [:show, :query_resource, :k2_subscription]
  include AccessToken
  # Landing Page
  # GET /webhooks
  def index
    @webhooks = Webhook.all
  end

  def show;  end

  def new
    @webhook = Webhook.new
  end

  def create
    subscribe
    @webhook = Webhook.new(subscribe_params)
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

  #def show
  #  @k2_subscription
  #  @k1_test_token
  #end

  # POST /webhooks/subscription
  def subscribe
    #if @k2_subscription.token_request(ENV["CLIENT_ID"], ENV["CLIENT_SECRET"])
    if @k2_subscription
      @k2_subscription.webhook_subscribe(ENV["K2_SECRET_KEY"], params[:subscription], webhooks_path)
      @k1_test_token = K2Client.new(ENV["K2_SECRET_KEY"])
    end

  end

  # Query Webhook
  # GET /query
  #def query_resource
  #  @k2_subscription.query_resource_url(@webhook.location_url)
  #end

  # POST
  def query_resource
    puts "Response: #{@k2_subscription.query_resource_url(@webhook.location_url)}"
    puts "Response: #{@k2_subscription.k2_response_body}"
    @webhook.response = @k2_subscription.k2_response_body
    respond_to do |format|
      if @webhook.save
        @webhook.reload
        format.html { redirect_to @webhook, notice: 'Webhook was successfully created.' }
        format.json { render :show, status: :created, location: @webhook }
      else
        format.html { render :new }
        format.json { render json: @webhook.errors, status: :unprocessable_entity }
      end
    end
  end

  # Process Results
  def process_results

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_webhook
    @webhook = Webhook.find(params[:id])
    request_token
    @k2_subscription = K2Subscribe.new(ENV["ACCESS_TOKEN"])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def webhook_params
    #params.require(:webhook).permit(:webhook_secret, :event_type, :location_url, :access_token, :response)
    #params.require(:webhook).permit(:subscription)
  end

  def subscribe_params
    { webhook_secret: ENV["K2_SECRET_KEY"], event_type: @k2_subscription.event_type, location_url: @k2_subscription.location_url, access_token: ENV["ACCESS_TOKEN"], response: @k2_subscription.k2_response_body }
  end

end