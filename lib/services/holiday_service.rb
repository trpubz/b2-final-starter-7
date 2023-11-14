require "assets/holiday"

class HolidayService
  @@holidays = []
  def self.us_holidays
    holidays = get_url("https://date.nager.at/api/v3/NextPublicHolidays/US")

    holidays.each do |holiday_data|
      @@holidays << Holiday.new(holiday_data)
    end
  end

  def self.get_url(url)
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.holidays
    @@holidays
  end
end
