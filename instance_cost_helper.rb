# instance_cost_helper.rb
# Computes average cost for a particular instance type, net of all
# reservations and such. Most algorithmically complex piece of this tool.

class InstanceCostHelper
  def initialize(reservations, running_instances)
    @reservations = reservations
    @running_instances = running_instances
  end
end
