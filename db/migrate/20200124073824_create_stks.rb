class CreateStks < ActiveRecord::Migration[5.2]
  def change
    create_table :stks do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :currency
      t.string :value
      t.string :location_url
      t.jsonb :response
      t.jsonb :result

      t.timestamps
    end
  end
end
