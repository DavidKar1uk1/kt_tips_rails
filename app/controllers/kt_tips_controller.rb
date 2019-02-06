class KtTipsController < ApplicationController
  attr_accessor :k2_subscription
  before_action :set_kt_tip, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, :only => [:receive, :subscribe]

  # POST /parse
  def receive
    k2_test = K2ConnectRuby::K2Client.new(ENV["K2_SECRET_KEY"])
    k2_test.parse_request(request)
    k2_truth_value = K2ConnectRuby::K2Authorize.new.authenticate?(k2_test.hash_body, k2_test.api_secret_key, k2_test.k2_signature)
    k2_components = K2ConnectRuby::K2SplitRequest.new(k2_truth_value)
    k2_components.judge_truth(k2_test.hash_body)
  end

  # POST /subscription
  def subscribe
    @k2_subscription = K2ConnectRuby::K2Subscribe.new("#{params[:subscription]}")
    if @k2_subscription.token_request(ENV["CLIENT_ID"], ENV["CLIENT_SECRET"])
      @k2_subscription.webhook_subscribe
      @k1_test_token = K2ConnectRuby::K2Client.new(ENV["K2_SECRET_KEY"])
      render 'kt_tips/show_subscription', :object => { :k2_subscription => @k2_subscription , :k1_test_token => @k1_test_token }
    end
  end

  # GET /subscription
  def subscription
  end

  # POST /stk_push
  def stk_push
    @k2_stk = K2ConnectRuby::K2Stk.new
    if @k2_stk.receive_payments("#{params[:first_name]}", "#{params[:last_name]}", "#{params[:phone]}", "#{params[:email]}", "#{params[:value]}")
      render 'kt_tips/show_stk'
    end
  end

  # GET /stk_push
  def stk
  end

  # GET /kt_tips
  # GET /kt_tips.json
  def index
    @kt_tips = KtTip.all
  end

  # GET /kt_tips/1
  # GET /kt_tips/1.json
  def show
  end

  # GET /kt_tips/new
  def new
    @kt_tip = KtTip.new
  end

  # GET /kt_tips/1/edit
  def edit
  end

  # POST /kt_tips
  # POST /kt_tips.json
  def create
    @kt_tip = KtTip.new(kt_tip_params)

    respond_to do |format|
      if @kt_tip.save
        format.html { redirect_to @kt_tip, notice: 'Kt tip was successfully created.' }
        format.json { render :show, status: :created, location: @kt_tip }
      else
        format.html { render :new }
        format.json { render json: @kt_tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kt_tips/1
  # PATCH/PUT /kt_tips/1.json
  def update
    respond_to do |format|
      if @kt_tip.update(kt_tip_params)
        format.html { redirect_to @kt_tip, notice: 'Kt tip was successfully updated.' }
        format.json { render :show, status: :ok, location: @kt_tip }
      else
        format.html { render :edit }
        format.json { render json: @kt_tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kt_tips/1
  # DELETE /kt_tips/1.json
  def destroy
    @kt_tip.destroy
    respond_to do |format|
      format.html { redirect_to kt_tips_url, notice: 'Kt tip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kt_tip
      @kt_tip = KtTip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kt_tip_params
      params.require(:kt_tip).permit(:topic, :content, :written_on, :likes)
    end

end
