# offered_instance.rb represents an instance on offer from amazon

class OfferedInstance
  include Comparable
  attr_accessor :price_per_hour, :availability_zone, :instance_type, :offer_type, :id
  
  def initialize(opts)
    opts.each do |k,v|
      instance_variable_set("@#{k}", v)
    end
  end

  def <=>(other)
    result = nil
    if other.respond_to?(:price_per_hour)
      receiver_value = self.price_per_hour
      argument_value = other.price_per_hour

      result = if receiver_value == argument_value
                 0
               elsif receiver_value < argument_value
                 -1
               else
                 1
               end
      end

      result
  end
end

