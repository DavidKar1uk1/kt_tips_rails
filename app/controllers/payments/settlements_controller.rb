module Payments
  class SettlementsController < PaymentsController
    before_action :set_settlement, only: [:show, :query_resource]
    # Landing Page
    # GET /payments/settlements
    def index
      @settlements = Settlement.all
      @mobile_accounts = Settlement.where(settlement_type: 'mobile_wallet')
      @bank_accounts = Settlement.where(settlement_type: 'bank_account')
    end

    def show;  end

    def new
      @settlement = Settlement.new
    end

    def create_settlement_account(params)
      set_k2settlement_object
      if @k2_settlement
        @k2_settlement.add_settlement_account(params.to_hash)
        puts "Location URL: #{@k2_settlement.location_url}"
        @resource_location = @k2_settlement.location_url
      end
    end

    def create
      puts "Settlement Type: #{settlement_params[:settlement_type]}"
      puts "Settlement Params: #{settlement_params}"
      create_settlement_account(k2_settlement_params)

      @settlement = Settlement.create(settlement_params.merge({ location_url: @resource_location }))
      respond_to do |format|
        if @settlement.save
          # Message Also changes as well.
          format.html { redirect_to @settlement, notice: 'Settlement was successfully created.' }
          format.json { render :show, status: :created, location: @settlement }
        else
          format.html { render :new }
          format.json { render json: @settlement.errors, status: :unprocessable_entity }
        end
      end
    end

    # POST
    def query_resource
      set_settlement
      set_k2settlement_object
      @k2_settlement.query_resource_url(@settlement.location_url)
      @settlement.response = @k2_settlement.k2_response_body
      respond_to do |format|
        if @settlement.save
          @settlement.reload
          format.html { redirect_to @settlement, notice: 'Object was successfully Queried.' }
          format.json { render :show, status: :created, location: @settlement }
        else
          format.html { render :new }
          format.json { render json: @settlement.errors, status: :unprocessable_entity }
        end
      end
    end

    # Process Results
    def process_settlement
      settlement_test = K2Client.new(ENV["CLIENT_SECRET"])
      settlement_test.parse_request(request)
      test_obj = K2ProcessResult.process(settlement_test.hash_body)
      puts "The Object:\t#{test_obj}"
      puts "The Object ID:\t#{test_obj.id}"
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_settlement
      @settlement = Settlement.find(params[:id])
    end

    def set_k2settlement_object
      request_token
      @k2_settlement = K2Settlement.new(ENV["ACCESS_TOKEN"])
    end

    def settlement_params
      params.require(:payments_settlement).permit(:msisdn, :network, :account_name, :account_number, :bank_id, :bank_branch_id, :settlement_type)
    end

    def k2_settlement_params
      params.require(:payments_settlement).permit(:msisdn, :network, :account_name, :account_number, :bank_id, :bank_branch_id).merge(type: settlement_params[:settlement_type])
    end
  end
end