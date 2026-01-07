class AddMetadataToSettlment < ActiveRecord::Migration[7.2]
  def change
    add_column(:settlements, :metadata, :jsonb)
  end
end
