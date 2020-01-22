json.extract! webhook, :id, :created_at, :updated_at
json.url webhook_url(webhook, format: :json)
