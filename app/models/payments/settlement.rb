module Payments
  class Settlement < ApplicationRecord
    store_accessor :metadata, :bank_branch_id, :bank_id, :settlement_type
  end
end
