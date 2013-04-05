# instance_cost_helper.rb
# Computes average cost for a particular instance type, net of all
# reservations and such. Most algorithmically complex piece of this tool.

require './offered_instance_collection'

class InstanceCostHelper
  def initialize(reservations, running_instances)
    @running_instances = running_instances
    @offered_instances = OfferedInstanceCollection.new(reservations)
  end

  def compute_costs

  end
end
