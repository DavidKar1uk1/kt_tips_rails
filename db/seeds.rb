# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
# Update DB to hold JSONB payload content, eg pay recipients and settlement accounts

# Add Webhook Subscription
WebhookSubscription.create(secret: 'webhook_secret', event: 'first seed data', location_url: 'initial seed', access_token: 'seed token', result: {seed: 'seed one'})

# Incoming Payments
Payments::Stk.create(first_name: 'David', last_name: 'Kariuki', phone: '254716230902', email: 'david.mwangi.john@gmail.com', currency: 'KES', value: '300', location_url: 'location_url', response: '{ test: text }', result: '{ test: text }')

# Add Mpesa Pay Recipient
Payments::PayRecipient.create(recipient_type: 'mobile_wallet', first_name: 'David', last_name: 'Kariuki', phone: '254716230902', email: 'david.mwangi.john@gmail.com', network: 'Safaricom', location_url: 'location_url')
# Add Bank Pay Recipient
Payments::PayRecipient.create(recipient_type: 'bank_account', first_name: 'David', last_name: 'Kariuki', phone: '254716230902', email: 'david.mwangi.john@gmail.com', account_name: 'David Kariuki', account_number: '7675484', bank_id: '5544678', bank_branch_id: '0011', location_url: 'location_url')

# Create Outgoing Payment
Payments::Pay.create(destination: '44effett-7484_028yfytte  ', currency: 'KES', value: '22200', location_url: 'location_url')

# Create Verified Mobile Settlement Account
Payments::Settlement.create(settlement_type: "merchant_wallet", phone_number: '254716230902', network: 'Safaricom')
# Create Verified Bank Settlement Account
Payments::Settlement.create(settlement_type: "merchant_bank_account", account_name: 'David Kariuki', account_number: '103301', bank_branch_ref: '633aa26c-7b7c-4091-ae28-96c0687cf886', settlement_method: 'EFT')
Payments::Settlement.create(settlement_type: "merchant_bank_account", account_name: 'John MWangi', account_number: '204402', bank_branch_ref: '633aa26c-7b7c-4091-ae28-96c0687cf886', settlement_method: 'RTS')

# Create blind Transfer
# Payments::Transfer.create(destination: nil, currency: 'USH', value: '40000')
# Create Transfer to merchant_bank_account
Payments::Transfer.create(destination_type: 'merchant_bank_account', destination_reference: 'merchant_bank_account', currency: 'KES', value: '40000')
# Create Transfer to merchant_wallet
Payments::Transfer.create(destination_type: 'merchant_wallet', destination_reference: 'merchant_wallet', currency: 'KES', value: '40000')