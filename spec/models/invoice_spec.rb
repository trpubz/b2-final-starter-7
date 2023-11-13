require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions }
  end
  describe "instance methods" do
    before(:each) do
      @merchant1 = Merchant.create!(name: "Hair Care")
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      @d1 = @merchant1.bulk_discounts.create!(discount: 0.20, min_qty: 5)
      @d2 = @merchant1.bulk_discounts.create!(discount: 0.25, min_qty: 6)
    end

    it "total_revenue" do
      expect(@invoice_1.total_revenue).to eq(100)
    end

    describe "#total_discounted_revenue" do
      it "calculates the total revenue with discounts" do
        expect(@invoice_1.total_discounted_revenue).to eq(
          @ii_1.quantity * @ii_1.discounted_price + @ii_11.quantity * @ii_11.unit_price
        )
      end
    end
  end
end
