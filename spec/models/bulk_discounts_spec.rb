require "rails_helper"

RSpec.describe BulkDiscount, type: :model do
  describe "validations" do
    it { should validate_presence_of :min_qty }
    it { should validate_presence_of :discount }
  end

  describe "relationships" do
    it { should belong_to :merchant }
  end

  describe "PORO extentsions" do
    describe "::to_discount_format" do
      it "formats the discount value" do
        discount = create(:bulk_discount, discount: 0.20)
        expect(discount.discount.to_discount_format).to eq "20% Off"
      end
    end
  end
end
