module Payments
  class TransfersController < PaymentsController
    before_action :set_transfer, only: [:show, :query_resource]
    # Landing Page
    # GET /payments/transfers
    def index
      @transfers = Payments::Transfer.all
    end

    def show;  end

    def new
      @transfer = Payments::Transfer.new
    end

    def create_transfer(params)
      set_k2transfer_object
      destination = transfer_params[:destination]
      if @k2_transfer
        @k2_transfer.transfer_funds(destination, params.to_hash.merge({ callback_url: payments_process_transfer_url }))
        puts "Location URL: #{@k2_transfer.transfer_location_url}"
        @resource_location = @k2_transfer.transfer_location_url
      end
    end

    def create
      puts "Transfer Params: #{transfer_params}"
      create_transfer JSON.parse(transfer_params)

      @transfer = Payments::Transfer.create(transfer_params)
      respond_to do |format|
        if @transfer.save
          format.html { redirect_to @transfer, notice: 'Object was successfully created.' }
          format.json { render :show, status: :created, location: @transfer }
        else
          format.html { render :new }
          format.json { render json: @transfer.errors, status: :unprocessable_entity }
        end
      end
    end

    # POST
    def query_resource
      set_transfer
      set_k2transfer_object
      @k2_transfer.query_resource_url(@transfer.location_url)
      @transfer.response = @k2_transfer.k2_response_body
      respond_to do |format|
        if @transfer.save
          @transfer.reload
          format.html { redirect_to @transfer, notice: 'Transfer was successfully Queried.' }
          format.json { render :show, status: :created, location: @transfer }
        else
          format.html { render :new }
          format.json { render json: @transfer.errors, status: :unprocessable_entity }
        end
      end
    end

    # Process Results
    def process_transfer
      transfer_test = K2Client.new(ENV["CLIENT_SECRET"])
      transfer_test.parse_request(request)
      test_obj = K2ProcessResult.process(transfer_test.hash_body)
      puts "The Object:\t#{test_obj}"
      puts "The Object ID:\t#{test_obj.id}"
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer
      @transfer = Transfer.find(params[:id])
    end

    def set_k2transfer_object
      request_token
      @k2_transfer = K2Transfer.new(ENV["ACCESS_TOKEN"])
    end

    def transfer_params
      params.require(:payments_transfer).permit(:destination, :currency, :value)
    end
  end
end