class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
    :item_id,
    :quantity,
    :unit_price,
    :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def discounted_price
    bulk_discount = item.merchant.bulk_discounts
                        .where("? >= min_qty", self.quantity)
                        .order(min_qty: :desc)
                        .first

    bulk_discount.nil? ? nil : (1 - bulk_discount.discount) * self.unit_price
  end
end
