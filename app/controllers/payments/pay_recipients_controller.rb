module Payments
  class PayRecipientsController < PaymentsController
    before_action :set_pay_recipient, only: [:show, :query_resource]
    before_action :set_pay_recipient_object, only: [:query_resource]
    before_action :init_pay_recipient, only: [:new_mobile_recipient, :new_bank_recipient, :new_till_recipient, :new_paybill_recipient]

    # Landing Page
    def index
      @pay_recipients = PayRecipient.all
    end

    def show;  end

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
      @k2_pay_recipient = K2ConnectRuby::K2Entity::K2Pay.new(@access_token)
    end

    def init_pay_recipient
      @pay_recipient = PayRecipient.new
    end

    def pay_recipient_params
      params.require(:payments_pay_recipient).permit(:first_name, :last_name, :phone, :email, :currency, :value,
        :network, :account_name, :account_number, :bank_branch_id, :recipient_type, :paybill_account_number)
    end
  end
end