class CreateSettlements < ActiveRecord::Migration[5.2]
  # Add Json column to aid in differentiating content
  def change
    create_table :settlements do |t|
      t.string :settlement_type
      t.string :account_name
      t.string :account_number
      t.string :bank_branch_ref
      t.string :settlement_method
      t.string :phone_number
      t.string :network
      t.string :location_url
      t.jsonb :response
      t.jsonb :result

      t.timestamps
    end
  end
end
