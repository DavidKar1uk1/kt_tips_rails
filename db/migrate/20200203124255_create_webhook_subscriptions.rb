class CreateWebhookSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :webhook_subscriptions do |t|
      t.string :secret
      t.string :event
      t.string :location_url
      t.string :access_token
      t.text :result

      t.timestamps
    end
  end
end
