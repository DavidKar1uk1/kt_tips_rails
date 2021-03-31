module Payments
  class PaysController < PaymentsController
    before_action :set_pay, only: [:show, :query_resource]
    before_action :set_pay_object, only: [:query_resource]
    before_action :create_pay, only: [:create]

    # Landing Page
    # GET /payments/pays
    def index
      @created_pays = Pay.all
    end

    def show;  end

    def new
      @pay = Pay.new
    end

    def create
      @pay = Pay.create(pay_params.merge({location_url: @resource_location }))
      respond_to do |format|
        if @pay.save
          # Message Also changes as well.
          format.html { redirect_to @pay, notice: 'Pay Object was successfully created.' }
          format.json { render :show, status: :created, location: @pay }
        else
          format.html { render :new }
          format.json { render json: @pay.errors, status: :unprocessable_entity }
        end
      end
    end

    # POST
    def query_resource
      @k2_pay.query_resource(@pay.location_url)
      @pay.response = @k2_pay.k2_response_body
      respond_to do |format|
        if @pay.save
          @pay.reload
          format.html { redirect_to @pay, notice: 'Pay Object was successfully Queried.' }
          format.json { render :show, status: :created, location: @pay }
        else
          format.html { render :new }
          format.json { render json: @pay.errors, status: :unprocessable_entity }
        end
      end
    end

    # Process Results
    def process_pay
      pay_test = K2Client.new(ENV["CLIENT_SECRET"])
      pay_test.parse_request(request)
      test_obj = K2ProcessResult.process(pay_test.hash_body)
      puts "The Object ID:\t#{test_obj.id}"
      response = K2ProcessWebhook.return_obj_hash(test_obj)
      unless test_obj.id.nil?
        respond_to do |format|
          format.json { render json: response }
        end
      end
    end

    private
    def set_pay
      @pay = Pay.find(params[:id])
    end

    def set_pay_object
      request_token
      @k2_pay = K2Pay.new(ENV["ACCESS_TOKEN"])
    end

    def pay_params
      params.require(:payments_pay).permit(:destination, :currency, :value)
    end

    def pay_request
      {
        destination_type: params[:payments_pay][:destination_type],
        destination_reference: pay_params[:destination],
        currency: pay_params[:currency],
        value: pay_params[:value],
        callback_url: payments_process_pay_url
      }
    end

    def create_pay
      set_pay_object
      if @k2_pay
        puts("Params: #{pay_request}")
        @k2_pay.create_payment(pay_request)
        @pay_test_token = K2Client.new(ENV["API_KEY"])
        @resource_location = @k2_pay.payments_location_url
      end
    end
  end
end