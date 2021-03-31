module Payments
  class PayRecipientsController < PaymentsController
    before_action :set_pay_recipient, only: [:show, :query_resource]
    before_action :set_pay_recipient_object, only: [:query_resource]
    before_action :add_pay_recipient, only: [:create]

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

    def create
      # Hidden field token to know, or tab pressed, or button used to indicate
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
      @k2_pay_recipient.query_resource(@pay_recipient.location_url)
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
      pay_recipient_test = K2Client.new(ENV["CLIENT_SECRET"])
      pay_recipient_test.parse_request(request)
      test_obj = K2ProcessResult.process(pay_recipient_test.hash_body)
      puts "The Object ID:\t#{test_obj.id}"
      response = K2ProcessWebhook.return_obj_hash(test_obj)
      unless test_obj.id.nil?
        respond_to do |format|
          format.json { render json: response }
        end
      end
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
      params.require(:payments_pay_recipient).permit(:first_name, :last_name, :phone, :email, :currency, :value, :network, :account_name, :account_number, :bank_branch_id, :recipient_type)
    end

    def mpesa_recipient_params
      {
        type: 'mobile_wallet',
        first_name: pay_recipient_params[:first_name],
        last_name: pay_recipient_params[:last_name],
        phone_number: pay_recipient_params[:phone],
        email: pay_recipient_params[:email],
        network: pay_recipient_params[:network],
      }
    end

    def bank_recipient_params
      {
        type: 'bank_account',
        account_name: pay_recipient_params[:account_name],
        account_number: pay_recipient_params[:account_number],
        bank_branch_ref: pay_recipient_params[:bank_branch_id],
        settlement_method: 'EFT'
      }
    end

    def add_pay_recipient
      set_pay_recipient_object
      if @k2_pay_recipient
        case params[:payments_pay_recipient][:order_type]
        when "mobile_wallet"
          puts("Params: #{mpesa_recipient_params}")
          @k2_pay_recipient.add_recipient(mpesa_recipient_params)
        when "bank_account"
          puts("Params: #{bank_recipient_params}")
          @k2_pay_recipient.add_recipient(bank_recipient_params)
        else
          puts("Nothing")
        end
        @pay_test_token = K2Client.new(ENV["API_KEY"])
        @resource_location = @k2_pay_recipient.recipients_location_url
      end
    end
  end
end