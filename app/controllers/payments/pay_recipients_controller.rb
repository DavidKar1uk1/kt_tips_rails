module Payments
  class PayRecipientsController < PaymentsController
    before_action :set_pay_recipient, only: [:show, :query_resource]
    # Landing Page
    # GET /payments/pays
    def index
      @mobile_accounts = PayRecipient.where(recipient_type: 'mobile_wallet')
      @bank_accounts = PayRecipient.where(recipient_type: 'bank_account')
    end

    def show;  end

    def new
      @pay_recipient = PayRecipient.new
    end

    def add_pay_recipient(params)
      set_pay_recipient_object
      if @k2_pay_recipient
        @k2_pay_recipient.pay_recipients(params.to_hash)
        @pay_test_token = K2Client.new(ENV["K2_SECRET_KEY"])
        puts "Location URL: #{@k2_pay_recipient.recipients_location_url}"
        @resource_location = @k2_pay_recipient.recipients_location_url
      end
    end

    def create
      # Hidden field token to know, or tab pressed, or button used to indicate?
      add_pay_recipient(pay_recipient_params)
      @pay_recipient = PayRecipient.create(pay_recipient_params.merge({location_url: @resource_location }))
      respond_to do |format|
        if @pay_recipient.save
          # Message Also changes as well.
          format.html { redirect_to @pay_recipient, notice: 'Pay Recipient was successfully created.' }
          format.json { render :show, status: :created, location: @pay_recipient }
        else
          format.html { render :new }
          format.json { render json: @pay_recipient.errors, status: :unprocessable_entity }
        end
      end
    end

    # POST
    def query_resource
      set_pay_recipient
      set_pay_recipient_object
      @k2_pay_recipient.query_resource_url(@pay_recipient.location_url)
      @pay_recipient.response = @k2_pay_recipient.k2_response_body
      respond_to do |format|
        if @pay_recipient.save
          @pay_recipient.reload
          format.html { redirect_to @pay_recipient, notice: 'Pay Recipient was successfully Queried.' }
          format.json { render :show, status: :created, location: @pay_recipient }
        else
          format.html { render :new }
          format.json { render json: @pay_recipient.errors, status: :unprocessable_entity }
        end
      end
    end

    # Process Results
    def process_pay_recipient
      bg_received_test = K2Client.new(ENV["CLIENT_SECRET"])
      bg_received_test.parse_request(request)
      test_obj = K2ProcessResult.process(bg_received_test.hash_body)
      puts "The Object:\t#{test_obj}"
      puts "The Object ID:\t#{test_obj.id}"
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_pay_recipient
      @pay_recipient = PayRecipient.find(params[:id])
    end

    def set_pay_recipient_object
      request_token
      @k2_pay_recipient = K2Pay.new(ENV["ACCESS_TOKEN"])
    end

    def pay_recipient_params
      params.require(:payments_pay_recipient).permit(:first_name, :last_name, :phone, :email, :currency, :value, :network, :account_name, :account_number, :bank_id, :bank_branch_id, :recipient_type)
    end
  end
end