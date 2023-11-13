class Invoice < ApplicationRecord
  validates_presence_of :status,
    :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_discounted_revenue
    invoice_items.reduce(0.0) do |tot, ii|
      discount = ii.discounted_price

      tot + if discount.nil?
        ii.unit_price * ii.quantity
      else
        discount * ii.quantity
      end
    end
  end
end
