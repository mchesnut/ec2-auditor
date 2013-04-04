require 'optparse'
require 'ostruct'
require 'awesome_print'
require 'debugger'
require './aws_connection'

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

aws_connection = AWSConnection.new(:access_key_id => options.aws_access_key,
  :secret_access_key => options.aws_secret_key)

#instance_type_counts = aws_connection.get_instances
#ap instance_type_counts

aws_connection.get_instance_reservations

