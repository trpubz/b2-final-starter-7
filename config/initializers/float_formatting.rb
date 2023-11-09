# Extending the Float class
class Float
  def to_discount_format
    # Format the float as a percentage with two decimal places
    # This will convert 0.15 to "15.00%" for example
    "#{(self * 100).round(0)}% Off"
  end
end
