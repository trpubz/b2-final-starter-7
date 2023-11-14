require_relative "../../lib/services/holiday_service"

Rails.cache.fetch("holidays", expires_in: 12.hours) do
  HolidayService.us_holidays
end

# Access cached holidays
Rails.cache.read("holidays")
