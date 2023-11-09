class BulkDiscount < ApplicationRecord
  validates_presence_of :min_qty
  validates_presence_of :discount

  belongs_to :merchant
end
