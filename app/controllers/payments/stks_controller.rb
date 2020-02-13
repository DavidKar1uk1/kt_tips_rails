module Payments
  class StksController < PaymentsController
    before_action :set_stk, only: [:show, :query_resource]

# Landing Page
# GET /payments/stks
    def index
      @stks = Stk.all
    end

    def show;  end

    def new
      @stk = Stk.new
    end

    def stk_push
      set_stk_push
      if @k2_stk
        @k2_stk.receive_mpesa_payments(stk_params.to_hash.merge({ callback_url: payments_process_stk_url }))
        @stk_test_token = K2Client.new(ENV["K2_SECRET_KEY"])
      end
    end

    def create
      stk_push
      #puts "Incoming Payment Object Created"
      #puts "STK Object: #{@k2_stk}"
      puts "STK Parameters: #{stk_params}"
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
      set_stk
      set_stk_push
      @k2_stk.query_resource_url(@stk.location_url)
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
      bg_received_test = K2Client.new(ENV["CLIENT_SECRET"])
      bg_received_test.parse_request(request)
      test_obj = K2ProcessResult.process(bg_received_test.hash_body)
      puts "The Object:\t\t#{test_obj}"
      puts "The Main ID:\t\t#{test_obj.id}"
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_stk
      @stk = Stk.find(params[:id])
    end

    def set_stk_push
      request_token
      @k2_stk = K2Stk.new(ENV["ACCESS_TOKEN"])
    end

    def stk_params
      params.require(:payments_stk).permit(:first_name, :last_name, :phone, :email, :currency, :value)
    end
  end
end