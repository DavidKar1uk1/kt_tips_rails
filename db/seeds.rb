# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Webhook.create(webhook_secret: 'webhook_secret', event_type: 'first seed data', location_url: 'initial seed', access_token: 'seed token', response: {seed: 'seed one'})