# offered_instance_collection.rb

require 'algorithms'
require './offered_instance'

class OfferedInstanceCollection
  def initialize(reservations)
    @offered_instances
    populate_on_demand
    populate_reservations(reservations)
  end
  
  def allocate!(type, az)
    min_cost_instance = @offered_instances[type][az].next!
    @offered_instances[type][az].push(min_cost_instance) if min_cost_instance.offer_type == 'demand'

    min_cost_instance
  end

  protected
  def populate_on_demand
    # Populate heaps for on-demand instances
    on_demand_hourly_prices = {
      "m1.small"    => 0.065,
      "m1.medium"   => 0.130,
      "m1.large"    => 0.260,
      "m1.xlarge"   => 0.520,
      "m3.large"    => 0.550,
      "m3.2xlarge"  => 1.100,
      "t1.micro"    => 0.025,
      "m2.xlarge"   => 0.460,
      "m2.2xlarge"  => 0.920,
      "m2.4xlarge"  => 1.840,
      "c1.medium"   => 0.165,
      "c1.xlarge"   => 0.660
    }

    @offered_instances = {}
    on_demand_hourly_prices.each do |instance_type, on_demand_hourly_price|
      @offered_instances[instance_type] = {
        "us-west-1a" => Containers::MinHeap.new([OfferedInstance.new(
          :price_per_hour => on_demand_hourly_price,
          :availability_zone => "us-west-1a",
          :instance_type => instance_type,
          :offer_type => 'demand')]),
        "us-west-1c" => Containers::MinHeap.new([OfferedInstance.new(
          :price_per_hour => on_demand_hourly_price,
          :availability_zone => "us-west-1c",
          :instance_type => instance_type,
          :offer_type => 'demand')]),
       }
    end 
  end

  def populate_reservations(reservations)
    reservations.each do |res|
      throw StandardError if res.recurring_charges[0][:frequency] != "Hourly"
      dollars_per_instance_month_opex = res.recurring_charges[0][:amount] * (24 * 30)

      res.instance_count.times do
        @offered_instances[res.instance_type][res.availability_zone].push(
          OfferedInstance.new(:price_per_hour => res.recurring_charges[0][:amount],
            :availability_zone => res.availability_zone,
            :instance_type => res.instance_type,
            :offer_type => 'reserved'))
      end
    end
  end
end

