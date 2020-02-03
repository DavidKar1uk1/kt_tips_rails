# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
WebhookSubscription.create(secret: 'webhook_secret', event: 'first seed data', location_url: 'initial seed', access_token: 'seed token', result: {seed: 'seed one'})
# Incoming Payments
Payments::Stk.create(first_name: 'David', last_name: 'Kariuki', phone: '254716230902', email: 'david.mwangi.john@gmail.com', currency: 'KES', value: '300', location_url: 'location_url', response: '{ test: text }', result: '{ test: text }')
# Add Mpesa Pay Recipient
Payments::Pay.create(first_name: 'David', last_name: 'Kariuki', phone: '254716230902', email: 'david.mwangi.john@gmail.com', network: 'Safaricom', location_url: 'location_url', order_type: 0)
# Add Bank Pay Recipient
Payments::Pay.create(first_name: 'David', last_name: 'Kariuki', phone: '254716230902', email: 'david.mwangi.john@gmail.com', account_name: 'David Kariuki', account_number: '7675484', bank_id: '5544678', bank_branch_id: '0011', location_url: 'location_url', order_type: 1)
# Create Outgoing Payment
Payments::Pay.create(currency: 'KES', value: '22200', location_url: 'location_url', order_type: 2)
# Verify Transfer
# Payments::Transfer.create()
# Create Transfer
# Payments::Transfer.create()