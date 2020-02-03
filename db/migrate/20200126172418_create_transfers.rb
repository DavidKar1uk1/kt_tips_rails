class CreateTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :transfers do |t|
      t.string :account_name
      t.string :account_number
      t.string :bank_ref_number
      t.string :bank_branch_ref_no
      t.string :target_destination
      t.string :amount
      t.string :location_url
      t.text :response
      t.text :result
      t.boolean :order_type

      t.timestamps
    end
  end
end
