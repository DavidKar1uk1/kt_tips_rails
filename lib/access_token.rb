module AccessToken
  def request_token
    ENV["ACCESS_TOKEN"] = K2AccessToken.new(ENV["CLIENT_ID"], ENV["CLIENT_SECRET"]).request_token
    @k1_test_token = K2Client.new(ENV["K2_SECRET_KEY"])
    ENV["ACCESS_TOKEN"]
  end
end