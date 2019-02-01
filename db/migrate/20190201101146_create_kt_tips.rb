class CreateKtTips < ActiveRecord::Migration[5.2]
  def change
    create_table :kt_tips do |t|
      t.string :topic
      t.string :content
      t.datetime :written_on
      t.integer :likes

      t.timestamps
    end
  end
end
