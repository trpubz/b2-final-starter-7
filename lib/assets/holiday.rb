require_relative "../../lib/services/holiday_service"
class Holiday
  attr_reader :date, :local_name
  def initialize(data)
    @date = data[:date]
    @local_name = data[:localName]
  end
end
