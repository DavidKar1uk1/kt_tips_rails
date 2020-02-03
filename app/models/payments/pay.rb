module Payments
  class Pay < ApplicationRecord
    serialize :hash
  end
end
