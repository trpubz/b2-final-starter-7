class ApplicationController < ActionController::Base
  before_action :set_next_holidays

  private

  def set_next_holidays
    holidays = Rails.cache.read("holidays") || HolidayService.holidays
    @next_holidays = holidays[0..2]
  end
end
