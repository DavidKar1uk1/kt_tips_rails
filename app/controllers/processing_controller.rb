# frozen_string_literal: true

class ProcessingController < ApplicationController
  protect_from_forgery except: [ :bg_received, :bg_reversed, :b2b, :m2m, :settle, :customer, :stk_payment, :wrong_stk_payment, :pay_payment ]
  # POST Buy Goods Received
  def webhook
    webhook = K2ConnectRuby::K2Services::K2Client.new(@api_key)
    webhook.parse_request(request)
    test_obj = K2ConnectRuby::K2Utilities::K2ProcessResult.process(webhook.hash_body, @api_key, webhook.k2_signature)
    puts "The Object:\t\t#{test_obj}"
    puts "The Main ID:\t\t#{test_obj.id}"
    puts "Resource ID:\t\t#{test_obj.resource_id}"
    puts "The Topic:\t\t#{test_obj.topic}"
    puts "The Type:\t\t#{test_obj.type}"
    puts "The First Name:\t\t#{test_obj.first_name}"
    puts "Middle Name:\t\t#{test_obj.middle_name}"
    puts "The Last Name:\t\t#{test_obj.last_name}"
  end

  def bg_received
    bg_received_test = K2ConnectRuby::K2Services::K2Client.new(@api_key)
    bg_received_test.parse_request(request)
    test_obj = K2ConnectRuby::K2Utilities::K2ProcessResult.process(bg_received_test.hash_body, @api_key, bg_received_test.k2_signature)
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
    bg_reversed_test = K2ConnectRuby::K2Services::K2Client.new(@api_key)
    bg_reversed_test.parse_request(request)
    test_obj = K2ConnectRuby::K2Utilities::K2ProcessResult.process(bg_reversed_test.hash_body, @api_key, bg_reversed_test.k2_signature)
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
    b2b_test = K2ConnectRuby::K2Services::K2Client.new(@api_key)
    b2b_test.parse_request(request)
    test_obj = K2ConnectRuby::K2Utilities::K2ProcessResult.process(b2b_test.hash_body, @api_key, b2b_test.k2_signature)
    puts "The Object:\t\t#{test_obj}"
    puts "The Main ID:\t\t#{test_obj.id}"
    puts "Resource ID:\t\t#{test_obj.resource_id}"
    puts "The Topic:\t\t#{test_obj.topic}"
    puts "The Type:\t\t#{test_obj.type}"
  end

  # POST card transaction received
  def card_transaction
    ct_received = K2ConnectRuby::K2Services::K2Client.new(@api_key)
    ct_received.parse_request(request)
    test_obj = K2ConnectRuby::K2Utilities::K2ProcessResult.process(ct_received.hash_body, @api_key, ct_received.k2_signature)
    puts "The Object:\t\t#{test_obj}"
    puts "The Main ID:\t\t#{test_obj.id}"
    puts "Resource ID:\t\t#{test_obj.resource_id}"
    puts "The Topic:\t\t#{test_obj.topic}"
    puts "The Type:\t\t#{test_obj.type}"
    puts "The First Name:\t\t#{test_obj.first_name}"
    puts "Middle Name:\t\t#{test_obj.middle_name}"
    puts "The Last Name:\t\t#{test_obj.last_name}"
  end

  # POST card transaction voided
  def card_transaction_voided
    ct_voided = K2ConnectRuby::K2Services::K2Client.new(@api_key)
    ct_voided.parse_request(request)
    test_obj = K2ConnectRuby::K2Utilities::K2ProcessResult.process(ct_voided.hash_body, @api_key, ct_voided.k2_signature)
    puts "The Object:\t\t#{test_obj}"
    puts "The Main ID:\t\t#{test_obj.id}"
    puts "Resource ID:\t\t#{test_obj.resource_id}"
    puts "The Topic:\t\t#{test_obj.topic}"
    puts "The Type:\t\t#{test_obj.type}"
    puts "The First Name:\t\t#{test_obj.first_name}"
    puts "Middle Name:\t\t#{test_obj.middle_name}"
    puts "The Last Name:\t\t#{test_obj.last_name}"
  end

  # POST card transaction reversed
  def card_transaction_reversed
    ct_reversed = K2ConnectRuby::K2Services::K2Client.new(@api_key)
    ct_reversed.parse_request(request)
    test_obj = K2ConnectRuby::K2Utilities::K2ProcessResult.process(ct_reversed.hash_body, @api_key, ct_reversed.k2_signature)
    puts "The Object:\t\t#{test_obj}"
    puts "The Main ID:\t\t#{test_obj.id}"
    puts "Resource ID:\t\t#{test_obj.resource_id}"
    puts "The Topic:\t\t#{test_obj.topic}"
    puts "The Type:\t\t#{test_obj.type}"
    puts "The First Name:\t\t#{test_obj.first_name}"
    puts "Middle Name:\t\t#{test_obj.middle_name}"
    puts "The Last Name:\t\t#{test_obj.last_name}"
  end

  # POST settlement
  def settle
    settle_test = K2ConnectRuby::K2Services::K2Client.new(@api_key)
    settle_test.parse_request(request)
    test_obj = K2ConnectRuby::K2Utilities::K2ProcessResult.process(settle_test.hash_body, @api_key, settle_test.k2_signature)
    puts "The Object:\t\t#{test_obj}"
    puts "The Main ID:\t\t#{test_obj.id}"
    puts "Resource ID:\t\t#{test_obj.resource_id}"
    puts "The Topic:\t\t#{test_obj.topic}"
    puts "The Type:\t\t#{test_obj.type}"
  end

  # POST customer
  def customer
    customer_test = K2ConnectRuby::K2Services::K2Client.new(@api_key)
    customer_test.parse_request(request)
    test_obj = K2ConnectRuby::K2Utilities::K2ProcessResult.process(customer_test.hash_body, @api_key, customer_test.k2_signature)
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
    stk_payment_test = K2ConnectRuby::K2Services::K2Client.new(@api_key)
    stk_payment_test.parse_request(request)
    test_obj = K2ConnectRuby::K2Utilities::K2ProcessResult.process(stk_payment_test.hash_body, @api_key, stk_payment_test.k2_signature)
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
    stk_payment_test = K2ConnectRuby::K2Services::K2Client.new(@api_key)
    stk_payment_test.parse_request(request)
    test_obj = K2ConnectRuby::K2Utilities::K2ProcessResult.process(stk_payment_test.hash_body, @api_key, stk_payment_test.k2_signature)
    puts "The Object:\t\t#{test_obj}"
    puts "The Main ID:\t\t#{test_obj.id}"
    puts "The Topic:\t\t#{test_obj.topic}"
    puts "The Type:\t\t#{test_obj.type}"
    puts "The Error Code:\t\t#{test_obj.error_code}"
    puts "Error Description:\t#{test_obj.error_description}"
  end

  # POST pay
  def pay_payment
    pay_payment_test = K2ConnectRuby::K2Services::K2Client.new(@api_key)
    pay_payment_test.parse_request(request)
    test_obj = K2ConnectRuby::K2Utilities::K2ProcessResult.process(pay_payment_test.hash_body, @api_key, pay_payment_test.k2_signature)
    puts "The Object:\t\t#{test_obj}"
    puts "The Main ID:\t\t#{test_obj.id}"
    puts "The Topic:\t\t#{test_obj.topic}"
  end
end
