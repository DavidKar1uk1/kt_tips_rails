module Payments
  class PaysController < PaymentsController
    before_action :set_pay, only: [:show, :query_resource]
    # Landing Page
    # GET /payments/pays
    def index
      @pay_recipients = Pay.where.not(order_type: 2)
      @created_pays = Pay.where(order_type: 2)
    end

    def show;  end

    def new
      @pay = Pay.new
    end

    def add_pay_recipient(params)
      set_pay_object
      if @k2_pay
        @k2_pay.pay_recipients(params.to_hash)
        @pay_test_token = K2Client.new(ENV["K2_SECRET_KEY"])
        puts "Location URL: #{@k2_pay.recipients_location_url}"
        @resource_location = @k2_pay.recipients_location_url
      end
    end

    def create_pay(params)
      set_pay_object
      if @k2_pay
        @k2_pay.create_payment(params.to_hash.merge({ callback_url: payments_pays_path }))
        @pay_test_token = K2Client.new(ENV["K2_SECRET_KEY"])
        puts "Location URL: #{@k2_pay.payments_location_url}"
        @resource_location = @k2_pay.payments_location_url
      end
    end

    def create
      puts "Order Type: #{pay_params[:order_type]}"
      # Create Check to see the intent and then select between adding pay recipient or creating pay
      # Hidden field token to know, or tab pressed, or button used to indicate?
      # TODO: In the Form, have a Tabbed pane to choose between Add Pay or Create Pay, and then a checked button or radio button fro Mpesa or Bank
      puts "Pay Params: #{pay_params}"
      if pay_params[:order_type].eql?('0')
        add_pay_recipient pay_params.merge(type: 'mobile_wallet').except(:order_type)
      elsif pay_params[:order_type].eql?('1')
        add_pay_recipient pay_params.merge(type: 'bank_account').except(:order_type)
      elsif pay_params[:order_type].eql?('2')
        create_pay pay_params.except(:order_type)
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
          format.html { redirect_to @pay, notice: 'Incoming Payment was successfully Queried.' }
          format.json { render :show, status: :created, location: @pay }
        else
          format.html { render :new }
          format.json { render json: @pay.errors, status: :unprocessable_entity }
        end
      end
    end

    # Process Results
    def process_results
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
      params.require(:payments_pay).permit(:first_name, :last_name, :phone, :email, :currency, :value, :network, :account_name, :account_number, :bank_id, :bank_branch_id, :type, :currency, :value, :order_type)
    end
  end
end