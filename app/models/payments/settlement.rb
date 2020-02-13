module Payments
  class Settlement < ApplicationRecord
    serialize :hash
  end
end
