class ProcessingController < ApplicationController
  protect_from_forgery except: [ :bg_received, :bg_reversed, :b2b, :m2m, :settle, :customer, :stk_payment, :wrong_stk_payment, :pay_payment ]
  # POST Buy Goods Received
  def bg_received
    # puts "Request:\t#{request.body.read}"
    bg_received_test = K2Client.new(ENV["K2_SECRET_KEY"])
    bg_received_test.parse_request(request)
    test_obj = K2ProcessResult.process(bg_received_test.hash_body)
    puts "The Object:\t\t#{test_obj}"
    puts "The Main ID:\t\t#{test_obj.id}"
    puts "Resource ID:\t\t#{test_obj.resource_id}"
    puts "The Topic:\t\t#{test_obj.topic}"
    puts "The Type:\t\t#{test_obj.type}"
    puts "The First Name:\t\t#{test_obj.first_name}"
    puts "Middle Name:\t\t#{test_obj.middle_name}"
    puts "The Last Name:\t\t#{test_obj.last_name}"
  end

  # POST Buy Goods Reversed
  def bg_reversed
    bg_received_test = K2Client.new(ENV["K2_SECRET_KEY"])
    bg_received_test.parse_request(request)
    test_obj = K2ProcessResult.process(bg_received_test.hash_body)
    puts "The Object:\t\t#{test_obj}"
    puts "The Main ID:\t\t#{test_obj.id}"
    puts "Resource ID:\t\t#{test_obj.resource_id}"
    puts "The Topic:\t\t#{test_obj.topic}"
    puts "The Type:\t\t#{test_obj.type}"
    puts "The First Name:\t\t#{test_obj.first_name}"
    puts "Middle Name:\t\t#{test_obj.middle_name}"
    puts "The Last Name:\t\t#{test_obj.last_name}"
  end

  # POST B2B
  def b2b
    bg_received_test = K2Client.new(ENV["K2_SECRET_KEY"])
    bg_received_test.parse_request(request)
    test_obj = K2ProcessResult.process(bg_received_test.hash_body)
    puts "The Object:\t\t#{test_obj}"
    puts "The Main ID:\t\t#{test_obj.id}"
    puts "Resource ID:\t\t#{test_obj.resource_id}"
    puts "The Topic:\t\t#{test_obj.topic}"
    puts "The Type:\t\t#{test_obj.type}"
  end

  # POST M2M
  def m2m
    bg_received_test = K2Client.new(ENV["K2_SECRET_KEY"])
    bg_received_test.parse_request(request)
    test_obj = K2ProcessResult.process(bg_received_test.hash_body)
    puts "The Object:\t\t#{test_obj}"
    puts "The Main ID:\t\t#{test_obj.id}"
    puts "Resource ID:\t\t#{test_obj.resource_id}"
    puts "The Topic:\t\t#{test_obj.topic}"
    puts "The Type:\t\t#{test_obj.type}"
  end

  # POST settlement
  def settle
    bg_received_test = K2Client.new(ENV["K2_SECRET_KEY"])
    bg_received_test.parse_request(request)
    test_obj = K2ProcessResult.process(bg_received_test.hash_body)
    puts "The Object:\t\t#{test_obj}"
    puts "The Main ID:\t\t#{test_obj.id}"
    puts "Resource ID:\t\t#{test_obj.resource_id}"
    puts "The Topic:\t\t#{test_obj.topic}"
    puts "The Type:\t\t#{test_obj.type}"
  end

  # POST customer
  def customer
    bg_received_test = K2Client.new(ENV["K2_SECRET_KEY"])
    bg_received_test.parse_request(request)
    test_obj = K2ProcessResult.process(bg_received_test.hash_body)
    puts "The Object:\t\t#{test_obj}"
    puts "The Main ID:\t\t#{test_obj.id}"
    puts "Resource ID:\t\t#{test_obj.resource_id}"
    puts "The Topic:\t\t#{test_obj.topic}"
    puts "The Type:\t\t#{test_obj.type}"
    puts "The First Name:\t\t#{test_obj.first_name}"
    puts "Middle Name:\t\t#{test_obj.middle_name}"
    puts "The Last Name:\t\t#{test_obj.last_name}"
  end

  # POST stk
  def stk_payment
    bg_received_test = K2Client.new(ENV["K2_SECRET_KEY"])
    bg_received_test.parse_request(request)
    test_obj = K2ProcessResult.process(bg_received_test.hash_body)
    puts "The Object:\t\t#{test_obj}"
    puts "The Main ID:\t\t#{test_obj.id}"
    puts "Resource ID:\t\t#{test_obj.resource_id}"
    puts "The Topic:\t\t#{test_obj.topic}"
    puts "The Type:\t\t#{test_obj.type}"
    puts "The First Name:\t\t#{test_obj.first_name}"
    puts "Middle Name:\t\t#{test_obj.middle_name}"
    puts "The Last Name:\t\t#{test_obj.last_name}"
  end

  # POST stk
  def wrong_stk_payment
    bg_received_test = K2Client.new(ENV["K2_SECRET_KEY"])
    bg_received_test.parse_request(request)
    test_obj = K2ProcessResult.process(bg_received_test.hash_body)
    puts "The Object:\t\t#{test_obj}"
    puts "The Main ID:\t\t#{test_obj.id}"
    puts "The Topic:\t\t#{test_obj.topic}"
    puts "The Type:\t\t#{test_obj.type}"
    puts "The Error Code:\t\t#{test_obj.error_code}"
    puts "Error Description:\t#{test_obj.error_description}"
  end

  # POST pay
  def pay_payment
    bg_received_test = K2Client.new(ENV["K2_SECRET_KEY"])
    bg_received_test.parse_request(request)
    puts "Body\t#{bg_received_test.hash_body.dig('amount')}"
    test_obj = K2ProcessResult.process(bg_received_test.hash_body)
    puts "The Object:\t\t#{test_obj}"
    puts "The Main ID:\t\t#{test_obj.id}"
    puts "The Topic:\t\t#{test_obj.topic}"
  end
end
