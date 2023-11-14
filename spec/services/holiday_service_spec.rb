require "rails_helper"

RSpec.describe HolidayService, type: :helper do
  describe "::get_url" do
    it "connects to external api" do
      expect(HolidayService.get_url("https://date.nager.at/api/v3/NextPublicHolidays/US")).to be_truthy
    end
  end

  describe "::us_holidays" do
    it "gets the us_holidays" do
      expect(HolidayService.us_holidays).to be_truthy
    end
  end

  describe "::holidays" do
    it "returns holiday objects from json" do
      HolidayService.us_holidays
      expect(HolidayService.holidays.first.local_name).to eq "Thanksgiving Day"
    end
  end
end
