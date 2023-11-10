FactoryBot.define do
  factory :bulk_discount do
    discount { Faker::Number.decimal(l_digits: 0, r_digits: 2) }
    min_qty { Faker::Number.decimal(l_digits: 2) }
    association :merchant, factory: :merchant
  end

  factory :customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Dessert.variety }
  end

  factory :invoice do
    status { [0, 1, 2].sample }
    association :customer, factory: :customer
  end

  factory :merchant do
    name { Faker::Space.galaxy }
  end

  factory :item do
    name { Faker::Coffee.variety }
    description { Faker::Hipster.sentence }
    unit_price { Faker::Number.decimal(l_digits: 2) }
    merchant
  end

  factory :transaction do
    result { [0, 1].sample }
    credit_card_number { Faker::Finance.credit_card }
    association :invoice, factory: :invoice
  end

  factory :invoice_item do
    status { [0, 1, 2].sample }
    association :invoice, factory: :invoice
  end
end
