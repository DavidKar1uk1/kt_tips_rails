# frozen_string_literal: true

require "k2-connect-ruby"

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
end
