require 'optparse'
require 'ostruct'
require 'awesome_print'
require 'aws'
require 'debugger'

class AuditorOptionParser
  def self.parse(args)
    options = OpenStruct.new
    options.aws_access_key = nil
    options.aws_secret_key = nil

    optparse = OptionParser.new do |opts|
      opts.banner = "Usage: auditor.rb [options]"
      opts.separator ""
      opts.separator "Specific options:"

      opts.on('-a', '--access-key AWS_ACCESS_KEY', "AWS access key") do |arg|
        options.aws_access_key = arg
      end

      opts.on('-s', '--secret-key AWS_SECRET_KEY', "AWS secret key") do |arg|
        options.aws_secret_key = arg
      end
    end

    optparse.parse!(args)
    options
  end
end

options = AuditorOptionParser.parse(ARGV)

config = { :access_key_id => options.aws_access_key,
  :secret_access_key => options.aws_secret_key }

# List all our instances in us-west-1
instance_type_counts = {}

ec2 = AWS::EC2.new(config)
ec2.regions['us-west-1'].instances.each do |instance|
  if instance.status.to_s == 'running'
    it = instance.instance_type
    instance_type_counts[it] = (instance_type_counts[it] || 0) + 1
  end
end

ap instance_type_counts

