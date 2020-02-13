class CreateTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :transfers do |t|
      t.string :destination
      t.string :currency
      t.string :value
      t.string :location_url
      t.jsonb :response
      t.jsonb :result

      t.timestamps
    end
  end
end
