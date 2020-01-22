class CreateWebhooks < ActiveRecord::Migration[5.2]
  def change
    create_table :webhooks do |t|
      t.string :webhook_secret
      t.string :event_type
      t.string :location_url
      t.string :access_token
      t.text :response

      t.timestamps
    end
  end
end
