require 'k2-connect-ruby'

class KtTipsController < ApplicationController
  before_action :set_kt_tip, only: [:show, :edit, :update, :destroy]

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

# git commit -m "In k2_webhook.rb changed for all classes related to K2FailedStk, i.e the parent classes "