class AddMetadataToPayRecipient < ActiveRecord::Migration[7.2]
  def change
    add_column(:pay_recipients, :metadata, :jsonb)
  end
end
