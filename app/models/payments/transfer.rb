module Payments
  class Transfer < ApplicationRecord
    serialize :hash
  end
end
