require "rails_helper"

describe "merchant discount edit page" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)

    @discount1 = @merchant1.bulk_discounts.create!(discount: 0.20, min_qty: 9)
    @discount2 = @merchant1.bulk_discounts.create!(discount: 0.25, min_qty: 12)
  end

  it "sees a form filled in with the discount attributes" do
    visit edit_merchant_discount_path(@merchant1, @discount1)

    expect(find_field("Discount").value).to eq(@discount1.discount.to_s)
    expect(find_field("Min Qty").value).to eq(@discount1.min_qty.to_s)
  end

  it "can fill in form, click submit, and redirect to that item's show page and see updated info and flash message" do
    visit edit_merchant_discount_path(@merchant1, @discount1)

    fill_in "Discount", with: ".33"
    fill_in "Min Qty", with: "33"
    @discount1.update!(discount: 0.33, min_qty: 33)

    click_button "Submit"

    expect(current_path).to eq(merchant_discount_path(@merchant1, @discount1))
    expect(page).to have_content(@discount1.discount.to_discount_format)
    expect(page).to have_content("Min Qty: #{@discount1.min_qty}")
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
