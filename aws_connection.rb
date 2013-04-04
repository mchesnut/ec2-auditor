require 'aws-sdk'
require 'debugger'

# aws_connection.rb
# Handles the credentials and gets data from AWS. Gets injected into
# things that require AWS connectivity.

class AWSConnection
  def initialize(opts)
    # Some kind of problem with initialization here, figure out later
    # Ended up sourcing these into environment which is super-hacky

    @ec2 = AWS::EC2.new(:access_key_id => opts[:access_key_id],
      :secret_access_key => opts[:aws_secret_key])
    
    #@ec2.config(:access_key_id => opts[:access_key_id],
    #  :secret_access_key => opts[:secret_access_key])

    ris = @ec2.regions['us-west-1'].reserved_instances

    debugger
    puts "Initialized"
    puts ris.count
  end

  def get_instance_reservations
    return 1
  end

  def get_instances # moved from main
    instance_type_counts = {}
    @ec2.regions['us-west-1'].instances.each do |instance|
      if instance.status.to_s == 'running'
        it = instance.instance_type
        instance_type_counts[it] = instance_type_counts[it] || 1
      end
    end
  end
end

    
