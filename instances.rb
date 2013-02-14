require 'awesome_print'
require 'chef'
require 'debugger'
 
chef_server_url = "http://lechef.crittercism.com:4000/"
client_name = "david"
signing_key_filename="/home/david/.chef/david.pem"
 
rest = Chef::REST.new(chef_server_url, client_name, signing_key_filename)
nodes = rest.get_rest("/nodes/")
 
JSON.create_id = ""

role_instances = {}

nodes.keys.each do |node_name|
  node = rest.get_rest("/nodes/#{node_name}/")
  
  puts "Analyzing node #{node_name}"
  role_record = (role_instances[node.run_list.to_s] || {})
  role_record[node[:ec2][:instance_type].to_s] =
    (role_record[node[:ec2][:instance_type].to_s] || 0) + 1

  role_instances[node.run_list.to_s] = role_record
end

ap role_instances

