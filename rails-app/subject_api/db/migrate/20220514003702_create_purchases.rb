class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_table :purchases do |t|
      t.bigint  :trade_id, null: false
      t.bigint  :seller_id, index: true, null: false
      t.bigint  :buyer_id,  index: true, null: false
      t.string  :item_name, null: false
      t.integer :points, null: false

      t.timestamps
    end
    add_index :purchases, [:trade_id], unique: true
    add_foreign_key :purchases, :users, column: :seller_id, primary_key: :id
    add_foreign_key :purchases, :users, column: :buyer_id,  primary_key: :id
  end
end
