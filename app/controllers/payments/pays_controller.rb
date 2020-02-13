module Payments
  class PaysController < PaymentsController
    before_action :set_pay, only: [:show, :query_resource]
    # Landing Page
    # GET /payments/pays
    def index
      @created_pays = Pay.all
    end

    def show;  end

    def new
      @pay = Pay.new
    end

    def create_pay(params)
      set_pay_object
      if @k2_pay
        @k2_pay.create_payment(params.to_hash.merge({ callback_url: payments_process_pay_url }))
        @pay_test_token = K2Client.new(ENV["K2_SECRET_KEY"])
        puts "Location URL: #{@k2_pay.location_url}"
        @resource_location = @k2_pay.location_url
      end
    end

    def create
      # Hidden field token to know, or tab pressed, or button used to indicate?
      if pay_params[:order_type].eql?('0')
        add_pay_recipient pay_params
      elsif pay_params[:order_type].eql?('1')
        add_pay_recipient pay_params
      elsif pay_params[:order_type].eql?('2')
        create_pay pay_params
      else
        return ArgumentError 'Invalid Order Type Parameter'
      end



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
      set_pay
      set_pay_object
      @k2_pay.query_resource_url(@pay.location_url)
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
      bg_received_test = K2Client.new(ENV["CLIENT_SECRET"])
      bg_received_test.parse_request(request)
      test_obj = K2ProcessResult.process(bg_received_test.hash_body)
      puts "The Object:\t#{test_obj}"
      puts "The Object ID:\t#{test_obj.id}"
    end

    private
    # Use callbacks to share common setup or constraints between actions.
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
  end
end