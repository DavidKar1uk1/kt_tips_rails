module Payments
  class SettlementsController < PaymentsController
    before_action :set_settlement, only: [:show, :query_resource]
    before_action :set_k2settlement_object, only: [:query_resource]
    before_action :create_settlement_account, only: [:create]

    # Landing Page
    # GET /payments/settlements
    def index
      @settlements = Settlement.all
      @mobile_accounts = Settlement.where(settlement_type: 'merchant_wallet')
      @bank_accounts = Settlement.where(settlement_type: 'merchant_bank_account')
    end

    def show;  end

    def new
      @settlement = Settlement.new
    end

    def create
      @settlement = Settlement.new(settlement_params.merge({ location_url: @resource_location }))
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
      @k2_settlement.query_resource(@settlement.location_url)
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
      settlement_test = K2ConnectRuby::K2Services::K2Client.new(ENV["CLIENT_SECRET"])
      settlement_test.parse_request(request)
      test_obj = K2ConnectRuby::K2Utilities::K2ProcessResult.process(settlement_test.hash_body, @api_key, settlement_test.k2_signature)
      puts "The Object ID:\t#{test_obj.id}"
      response =  K2ConnectRuby::K2Utilities::K2ProcessWebhook.return_obj_hash(test_obj)
      unless test_obj.id.nil?
        respond_to do |format|
          format.json { render json: response }
        end
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_settlement
      @settlement = Settlement.find(params[:id])
    end

    def set_k2settlement_object
      request_token
      @k2_settlement = K2ConnectRuby::K2Entity::K2Settlement.new(@access_token)
    end

    def settlement_params
      params.require(:payments_settlement).permit(:msisdn, :network, :account_name, :account_number, :bank_id, :bank_branch_id, :settlement_type)
    end

    def mobile_settlement_account
      {
        type: settlement_params[:settlement_type],
        first_name: params[:payments_settlement][:first_name],
        last_name: params[:payments_settlement][:last_name],
        phone_number: settlement_params[:msisdn],
        network: settlement_params[:network]
      }
    end

    def bank_settlement_account
      {
        type: settlement_params[:settlement_type],
        account_name: settlement_params[:account_name],
        account_number: settlement_params[:account_number],
        bank_branch_ref: settlement_params[:bank_branch_id],
        settlement_method: 'EFT'
      }
    end

    def create_settlement_account
      set_k2settlement_object
      if @k2_settlement
        case settlement_params[:settlement_type]
        when 'merchant_wallet'
          @k2_settlement.add_settlement_account(mobile_settlement_account)
        when 'merchant_bank_account'
          @k2_settlement.add_settlement_account(bank_settlement_account)
        else
          "Nothing"
        end
        @resource_location = @k2_settlement.location_url
      end
    end
  end
end