class CreatePays < ActiveRecord::Migration[5.2]
  def change
    create_table :pays do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :network
      t.string :account_name
      t.string :account_number
      t.string :bank_id
      t.string :bank_branch_id
      t.string :currency
      t.string :value
      t.string :location_url
      t.text :response
      t.text :result
      t.integer :order_type

      t.timestamps
    end
  end
end
