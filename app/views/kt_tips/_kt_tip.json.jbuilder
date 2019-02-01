json.extract! kt_tip, :id, :topic, :content, :written_on, :likes, :created_at, :updated_at
json.url kt_tip_url(kt_tip, format: :json)
