# frozen_string_literal: true

module Payments
  class PayRecipientsController < PaymentsController
    before_action :set_pay_recipient, only: [:show, :query_resource]
    before_action :set_pay_recipient_object, only: [:query_resource]
    before_action :init_pay_recipient, only: [:new_mobile_recipient, :new_bank_recipient, :new_till_recipient, :new_paybill_recipient]

    # Landing Page
    def index
      @pay_recipients = PayRecipient.all
    end

    def show; end

    def new_mobile_recipient; end

    def new_bank_recipient; end

    def new_till_recipient; end

    def new_paybill_recipient; end

    def create
      result = CreatePayRecipientService.call(pay_recipient_params)
      puts("Result: #{result}")

      if result.success?
        flash[:success] = "Pay Recipient was successfully created."
        redirect_to(action: :show, id: result.data&.id)
      else
        flash[:alert] = "Error when saving external recipient - #{result.errors}"
        redirect_to(action: :index)
      end
    end

    # POST
    def query_resource
      @k2_pay_recipient.query_resource(@pay_recipient.location_url)
      @pay_recipient.response = @k2_pay_recipient.k2_response_body
      if @pay_recipient.save
        @pay_recipient.reload
        redirect_to @pay_recipient, notice: 'Pay Recipient was successfully Queried.'
      else
        redirect_to @pay_recipient, error: "Error when saving external recipient - #{@pay_recipient.errors.full_messages.join(",")}"
      end
    end

    # Process Results
    def process_pay_recipient
      pay_recipient_test = K2ConnectRuby::K2Services::K2Client.new(ENV["CLIENT_SECRET"])
      pay_recipient_test.parse_request(request)
      test_obj = K2ConnectRuby::K2Utilities::K2ProcessResult.process(pay_recipient_test.hash_body, @api_key, pay_recipient_test.k2_signature)
      response =  K2ConnectRuby::K2Utilities::K2ProcessWebhook.return_obj_hash(test_obj)
      unless test_obj.id.nil?
        respond_to do |format|
          format.json { render(json: response) }
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
      @k2_pay_recipient = K2ConnectRuby::K2Entity::ExternalRecipient.new(@access_token)
    end

    def init_pay_recipient
      @pay_recipient = PayRecipient.new
    end

    def pay_recipient_params
      params.require(:payments_pay_recipient).permit(:first_name, :last_name, :phone, :email, :currency, :value,
        :network, :account_name, :account_number, :bank_branch_id, :recipient_type, :paybill_account_number)
    end

    def mpesa_recipient_params
      {
        type: "mobile_wallet",
        first_name: pay_recipient_params[:first_name],
        last_name: pay_recipient_params[:last_name],
        phone_number: pay_recipient_params[:phone],
        email: pay_recipient_params[:email],
        network: pay_recipient_params[:network],
      }
    end

    def bank_recipient_params
      {
        type: "bank_account",
        account_name: pay_recipient_params[:account_name],
        account_number: pay_recipient_params[:account_number],
        bank_branch_ref: pay_recipient_params[:bank_branch_id],
      }
    end

    def till_recipient_params
      {
        type: "till",
        till_name: pay_recipient_params[:account_name],
        till_number: pay_recipient_params[:account_number],
      }
    end

    def paybill_recipient_params
      {
        type: "paybill",
        paybill_name: pay_recipient_params[:account_name],
        paybill_number: pay_recipient_params[:account_number],
        paybill_account_number: pay_recipient_params[:paybill_account_number],
      }
    end

    def add_pay_recipient
      set_pay_recipient_object
      if @k2_pay_recipient
        case params[:payments_pay_recipient][:order_type]
        when "mobile_wallet"
          puts("Params: #{mpesa_recipient_params}")
          @k2_pay_recipient.add_external_recipient(mpesa_recipient_params)
        when "bank_account"
          puts("Params: #{bank_recipient_params}")
          @k2_pay_recipient.add_external_recipient(bank_recipient_params)
        when "till"
          puts("Params: #{till_recipient_params}")
          @k2_pay_recipient.add_external_recipient(bank_recipient_params)
        when "paybill"
          puts("Params: #{paybill_recipient_params}")
          @k2_pay_recipient.add_external_recipient(bank_recipient_params)
        else
          puts("Nothing")
        end
        @pay_test_token = K2ConnectRuby::K2Services::K2Client.new(@api_key)
        @resource_location = @k2_pay_recipient.recipients_location_url
      end
    end
  end
end