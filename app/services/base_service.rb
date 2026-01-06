# frozen_string_literal: true

class BaseService
  CallResult = Struct.new(:success?, :data, :errors)

  class << self
    def call(*args, &block)
      new(*args, &block).execute
    end
  end
end
