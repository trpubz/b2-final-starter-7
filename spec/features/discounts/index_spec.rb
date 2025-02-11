require "rails_helper"

RSpec.describe "Bulk Discounts Index Page", type: :feature do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @discount1 = @merchant1.bulk_discounts.create!(discount: 0.20, min_qty: 20)
  end

  it "allows creation of new discounts" do
    # 2: Merchant Bulk Discount Create
    #
    # As a merchant
    # When I visit my bulk discounts index
    # Then I see a link to create a new discount
    # When I click this link
    # Then I am taken to a new page where I see a form to add a new bulk discount
    # When I fill in the form with valid data
    # Then I am redirected back to the bulk discount index
    # And I see my new bulk discount listed
    visit merchant_discounts_path(@merchant1)

    click_link "Create New Discount"

    expect(page).to have_current_path new_merchant_discount_path(@merchant1)

    fill_in "Discount", with: "0.33"
    fill_in "Min Qty", with: "33"

    click_button "Create"

    expect(page).to have_current_path merchant_discounts_path(@merchant1)

    within("#discount-#{@merchant1.bulk_discounts.last.id}") do
      expect(page).to have_content @merchant1.bulk_discounts.last.discount.to_discount_format
      expect(page).to have_content "Min Qty: #{@merchant1.bulk_discounts.last.min_qty}"
    end
  end

  context "user enters bad info into the Create form" do
    it "flashes an alert on bad Discount data" do
      visit new_merchant_discount_path(@merchant1)

      fill_in "Discount", with: "AA"
      fill_in "Min Qty", with: "33"

      click_button "Create"

      expect(page).to have_content "Invalid Inputs: ensure discount is a decimal and minimum quantity is a whole number"
    end

    it "flashes an alert on bad Min Qty data" do
      visit new_merchant_discount_path(@merchant1)

      fill_in "Discount", with: "0.33"
      fill_in "Min Qty", with: "AA"

      click_button "Create"

      expect(page).to have_content "Invalid Inputs: ensure discount is a decimal and minimum quantity is a whole number"
    end
  end

  it "allows user to delete bulk discount" do
    # 3: Merchant Bulk Discount Delete
    #
    # As a merchant
    # When I visit my bulk discounts index
    # Then next to each bulk discount I see a button to delete it
    # When I click this button
    # Then I am redirected back to the bulk discounts index page
    # And I no longer see the discount listed
    visit merchant_discounts_path(@merchant1)

    within("#discount-#{@discount1.id}") do
      click_button "Delete"
    end

    expect(page).to_not have_content "Discount #{@discount1.id}"
  end

  it "has a section with next 3 upcoming holidays" do
    # Holidays API
    #
    # As a merchant
    # When I visit the discounts index page
    # I see a section with a header of "Upcoming Holidays"
    # In this section the name and date of the next 3 upcoming US holidays are listed.
    #
    # Use the Next Public Holidays Endpoint in the [Nager.Date API](https://date.nager.at/swagger/index.html)
    visit merchant_discounts_path(@merchant1)

    within(".upcoming-holidays") do
      expect(page).to have_content "Thanksgiving Day | 2023-11-23"
    end
  end
end
