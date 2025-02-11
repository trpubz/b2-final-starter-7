require "rails_helper"

RSpec.describe "Bulk Discounts show Page", type: :feature do
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

  it "shows the discounts details" do
    # 4: Merchant Bulk Discount Show
    #
    # As a merchant
    # When I visit my bulk discount show page
    # Then I see the bulk discount's quantity threshold and percentage discount
    visit merchant_discount_path(@merchant1, @discount1)

    expect(page).to have_content @discount1.discount.to_discount_format
    expect(page).to have_content @discount1.min_qty
  end

  it "has a feature to edit the discount" do
    # 5: Merchant Bulk Discount Edit
    #
    # As a merchant
    # When I visit my bulk discount show page
    # Then I see a link to edit the bulk discount
    # When I click this link
    # Then I am taken to a new page with a form to edit the discount
    # And I see that the discounts current attributes are pre-poluated in the form
    # When I change any/all of the information and click submit
    # Then I am redirected to the bulk discount's show page
    # And I see that the discount's attributes have been updated
    visit merchant_discount_path(@merchant1, @discount1)

    click_button "Edit"

    expect(page).to have_current_path edit_merchant_discount_path(@merchant1, @discount1)

    discount = ".33"
    qty = "33"
    fill_in "Discount", with: discount
    fill_in "Min Qty", with: qty
    click_button "Submit"
    @discount1.update!(discount: discount, min_qty: qty)

    expect(page).to have_current_path merchant_discount_path(@merchant1, @discount1)

    expect(page).to have_content @discount1.discount.to_discount_format
    expect(page).to have_content @discount1.min_qty
  end

  context "bad data is passed in the edit form" do
    it "has a renders the edit form with flash alert" do
      # 5: Merchant Bulk Discount Edit
      #
      # As a merchant
      # When I visit my bulk discount show page
      # Then I see a link to edit the bulk discount
      # When I click this link
      # Then I am taken to a new page with a form to edit the discount
      # And I see that the discounts current attributes are pre-poluated in the form
      # When I change any/all of the information and click submit
      # Then I am redirected to the bulk discount's show page
      # And I see that the discount's attributes have been updated
      visit edit_merchant_discount_path(@merchant1, @discount1)

      discount = ".aa"
      qty = "3a"
      fill_in "Discount", with: discount
      fill_in "Min Qty", with: qty
      click_button "Submit"
      # @discount1.update(discount: discount, min_qty: qty)

      expect(page).to have_content "Invalid Inputs: ensure discount is a decimal and minimum quantity is a whole number"
    end
  end
end
