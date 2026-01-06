class CreatePayRecipientService < BaseService
  include AccessToken
  attr_reader :pay_recipient_params, :resource_location

  def initialize(pay_recipient_params)
    super()
    @pay_recipient_params = pay_recipient_params
  end

  def execute
    send_pay_recipient_request
    return CallResult.new(false, nil, "Failed to send add external recipient request.") if resource_location.blank?

    pay_recipient = Payments::PayRecipient.new(pay_recipient_params.merge({location_url: resource_location }))
    if pay_recipient.save
      CallResult.new(true, pay_recipient.reload, [])
    else
      CallResult.new(false, pay_recipient, pay_recipient.errors.full_messages)
    end
  rescue StandardError => ex
    logger.error("Unexpected error when creating pay recipient: #{[ex.message, ex.backtrace].join("\n\t")}")
    CallResult.new(false, nil, "Unexpected error when creating pay recipient.")
  end

  private

  def send_pay_recipient_request
    request_token
    k2_pay_recipient = K2ConnectRuby::K2Entity::K2Pay.new(@access_token)
    if k2_pay_recipient.present?
      case pay_recipient_params[:recipient_type]
      when "mobile_wallet"
        k2_pay_recipient.add_recipient(mpesa_recipient_params)
      when "bank_account"
        k2_pay_recipient.add_recipient(bank_recipient_params)
      when "till"
        k2_pay_recipient.add_recipient(till_recipient_params)
      when "paybill"
        k2_pay_recipient.add_recipient(paybill_recipient_params)
      else
        raise("Invalid recipient type")
      end
      @resource_location = k2_pay_recipient.recipients_location_url
    end
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
      settlement_method: "RTS"
    }
  end

  def till_recipient_params
    {
      type: 'till',
      till_name: pay_recipient_params[:account_name],
      till_number: pay_recipient_params[:account_number],
    }
  end

  def paybill_recipient_params
    {
      type: 'paybill',
      paybill_name: pay_recipient_params[:account_name],
      paybill_number: pay_recipient_params[:account_number],
      paybill_account_number: pay_recipient_params[:paybill_account_number],
    }
  end

  def logger
    @logger || Logger.new('log/create_pay_recipient.log')
  end
end
