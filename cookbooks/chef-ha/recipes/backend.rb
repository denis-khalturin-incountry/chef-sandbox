log 'message' do
  message  "packages:\n#{node['hostname']}"
  level    :info
end

log 'message' do
  message  "databag:\nBACKEND:#{data_bag('backend')}\nFRONTEND:#{data_bag('frontend')}"
  level    :info
end

data = data_bag_item('backend', node['hostname'])

log 'message' do
  message  "databag:\n#{data['leader']}; #{data['leader'] === true}; #{data['ip']}"
  level    :info
end

file '/etc/chef-backend/chef-backend.rb' do
  content "publish_address '#{node['ipaddress']}'"
end

file '/tmp/foo.txt' do
  content 'foos'
  action :nothing
  subscribes :create, [ 'file[/tmp/bar.txt]', 'file[/tmp/baz.txt]' ]
end
file '/tmp/bar.txt' do
  content 'bar'
end
file '/tmp/baz.txt' do
  content 'baz'
end

# bash 'cluster-status' do
#   code 'w'
#   # code 'chef-backend-ctl cluster-status'
#   ignore_failure :quiet

#   # only_if { data['leader'] != true }
# end

log 'message' do
  message  "TEST"
  level    :info
  action :nothing
  subscribes :create, [ 'file[/tmp/foo.txt]' ]
  # subscribes :create, [ 'bash[cluster-status]' ]
end


# if data['leader'] === true
#   log 'message' do
#     message  shell_out("")
#     level    :info
#   end
#   # bash 'create-cluster' do
#   #   code 'chef-backend-ctl create-cluster --accept-license'
#   #   # only_if { data['leader'] === true }
#   # end

#   # data_bag('backend').each do |host|
#   #   log 'message' do
#   #     message  "HOST: #{host}"
#   #     level    :info
#   #   end
#   # end
# end
