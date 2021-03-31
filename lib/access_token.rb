# TODO: Set up Global Tokens that are used by every module
require 'k2-connect-ruby/k2_financial_entity/k2_token'

module AccessToken
  def request_token
    ENV["ACCESS_TOKEN"] = K2AccessToken.new(ENV["CLIENT_ID"], ENV["CLIENT_SECRET"]).request_token
    @k1_test_token = K2Client.new(ENV["API_KEY"])
    ENV["ACCESS_TOKEN"]
  end
end