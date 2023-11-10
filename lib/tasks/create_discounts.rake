require "faker"

namespace :create_discounts do
  task load: :environment do
    Merchant.all.each do |merchant|
      2.times {
        merchant.bulk_discounts.create!(
          discount: Faker::Number.decimal(l_digits: 0, r_digits: 2),
          min_qty: Faker::Number.decimal(l_digits: 2)
        )
      }
    end
  end
end
