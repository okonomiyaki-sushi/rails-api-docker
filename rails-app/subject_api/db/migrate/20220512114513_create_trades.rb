class CreateTrades < ActiveRecord::Migration[7.0]
  def change
    create_table :trades do |t|
      t.bigint  :seller_id, index: true, null: false
      t.string  :item_name, null: false
      t.integer :points,    null: false, limit: 2
      t.boolean :closed, default: false, null: false

      t.timestamps
    end
    add_index :trades, :closed
    add_foreign_key :trades, :users, column: :seller_id, primary_key: :id
  end
end
