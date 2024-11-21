class AddMsisdnToSettlement < ActiveRecord::Migration[7.2]
  def change
    add_column(:settlements, :msisdn, :string)
  end
end
