class CreateBulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :bulk_discounts do |t|
      t.float :discount
      t.integer :min_qty
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
