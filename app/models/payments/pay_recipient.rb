module Payments
  class PayRecipient < ApplicationRecord
    store_accessor :metadata, :paybill_account_number, :settlement_method

    def mobile_recipient?
      recipient_type.eql?("mobile_wallet")
    end

    def bank_recipient?
      recipient_type.eql?("bank_account")
    end

    def till_recipient?
      recipient_type.eql?("till")
    end

    def paybill_recipient?
      recipient_type.eql?("paybill")
    end

    def recipient_name
      return account_name unless mobile_recipient?

      "#{first_name} #{last_name}".squish
    end

    def account_identifier
      return account_number unless mobile_recipient?

      phone
    end
  end
end