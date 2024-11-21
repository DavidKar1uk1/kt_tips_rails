module AccessToken
  def request_token
    @client_id = Rails.application.credentials.kt_tips_rails[:client_id]
    @client_secret = Rails.application.credentials.kt_tips_rails[:client_secret]
    @api_key = Rails.application.credentials.kt_tips_rails[:api_key]
    @access_token = K2ConnectRuby::K2Entity::K2Token.new(@client_id, @client_secret).request_token
  end
end