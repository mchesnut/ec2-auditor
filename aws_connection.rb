require 'aws-sdk'

# aws_connection.rb
# Handles the credentials and gets data from AWS. Gets injected into
# things that require AWS connectivity.

class AWSConnection
  def initialize(opts)
    @ec2 = AWS::EC2.new(:access_key_id => opts[:access_key_id],
      :secret_access_key => opts[:secret_access_key])
  end

  # filters is a hash of key/value pairs for equality comparison
  # maybe generalize this later but not now.
  def get_instance_reservations(filters = {})
    AWS.memoize do
      @ec2.regions['us-west-1'].reserved_instances.select do |ins|
        filters.reduce(true) do |memo, filter_kvp|
          memo && ins.send(filter_kvp[0]) == filter_kvp[1]
        end
      end
    end
  end

  def get_instances(filters = {})
    AWS.memoize do
      @ec2.regions['us-west-1'].instances.select do |ins|
        filters.reduce(true) do |memo, filter_kvp|
          memo && ins.send(filter_kvp[0]) == filter_kvp[1]
        end
      end
    end
  end
end

