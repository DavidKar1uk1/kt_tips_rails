class CreatePayRecipients < ActiveRecord::Migration[5.2]
  def change
    create_table :pay_recipients do |t|
      t.string :recipient_type
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :network
      t.string :account_name
      t.string :account_number
      t.string :bank_id
      t.string :bank_branch_id
      t.string :location_url
      t.jsonb :response
      t.jsonb :result

      t.timestamps
    end
  end
end
