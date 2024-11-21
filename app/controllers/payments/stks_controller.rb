module Payments
  class StksController < PaymentsController
    before_action :set_stk, only: [:show, :query_resource]
    before_action :set_stk_push, only: [:query_resource]
    before_action :stk_push, only: [:create]

# Landing Page
# GET /payments/stks
    def index
      @stks = Stk.all
    end

    def show;  end

    def new
      @stk = Stk.new
    end

    def create
      @stk = Stk.create(stk_params.merge({ location_url: @k2_stk.location_url }))
      respond_to do |format|
        if @stk.save
          format.html { redirect_to @stk, notice: 'Incoming Payment was successfully created.' }
          format.json { render :show, status: :created, location: @stk }
        else
          format.html { render :new }
          format.json { render json: @stk.errors, status: :unprocessable_entity }
        end
      end
    end

    # POST
    def query_resource
      @k2_stk.query_resource(@stk.location_url)
      @stk.response = @k2_stk.k2_response_body
      respond_to do |format|
        if @stk.save
          @stk.reload
          format.html { redirect_to @stk, notice: 'Incoming Payment was successfully Queried.' }
          format.json { render :show, status: :created, location: @stk }
        else
          format.html { render :new }
          format.json { render json: @stk.errors, status: :unprocessable_entity }
        end
      end
    end

    # Process Results
    def process_stk
      request_token
      stk_test = K2ConnectRuby::K2Services::K2Client.new(@api_key)
      stk_test.parse_request(request)
      test_obj = K2ConnectRuby::K2Utilities::K2ProcessResult.process(stk_test.hash_body, @api_key, stk_test.k2_signature)
      puts "The Main ID:\t\t#{test_obj.id}"
      response =  K2ConnectRuby::K2Utilities::K2ProcessWebhook.return_obj_hash(test_obj)
      unless test_obj.id.nil?
        respond_to do |format|
          format.json { render json: response }
        end
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_stk
      @stk = Stk.find(params[:id])
    end

    def set_stk_push
      request_token
      @k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(@access_token)
    end

    def stk_params
      params.require(:payments_stk).permit(:first_name, :last_name, :phone, :email, :currency, :value)
    end

    def stk_request
      {
        payment_channel: 'M-PESA',
        till_number: 'K112233',
        first_name: stk_params[:first_name],
        last_name: stk_params[:last_name],
        phone_number: stk_params[:phone],
        email: stk_params[:email],
        currency: stk_params[:currency],
        value: stk_params[:value],
        callback_url: "https://021c-197-248-175-34.ngrok-free.app/payments/stks/results"
      }
    end

    def stk_push
      set_stk_push
      if @k2_stk
        @k2_stk.receive_mpesa_payments(stk_request)
        @stk_test_token = K2ConnectRuby::K2Services::K2Client.new(@api_key)
      end
    end
  end
end