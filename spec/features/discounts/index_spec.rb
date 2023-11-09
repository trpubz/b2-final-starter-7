require "rails_helper"

RSpec.describe "Bulk Discounts Index Page", type: :feature do
  it "allows creation of new discounts" do
    expect(page).to have_link "Create New Discount"
  end
end
