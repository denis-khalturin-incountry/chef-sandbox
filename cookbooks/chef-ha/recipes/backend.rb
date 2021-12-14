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

directory '/etc/chef-backend' do
  action :create
end

file '/etc/chef-backend/chef-backend.rb' do
  content "publish_address '#{node['ipaddress']}'"
end

bash 'cluster-status' do
  code 'chef-backend-ctl cluster-status'
  returns 1
  ignore_failure :quiet

  only_if { !!data['leader'] }
end

bash 'cluster-create' do
  code 'chef-backend-ctl create-cluster --accept-license'

  action :nothing
  subscribes :run, [ 'bash[cluster-status]' ]

  only_if { !!data['leader'] }
end

log 'message' do
  message "TEST"
  level :info
  action :nothing
  subscribes :write, [ 'bash[cluster-create]' ]
end

# data_bag('backend').each do |host|
#   log 'message' do
#     message "HOST: #{host}"
#     level :info
#     action :nothing
#     subscribes :write, [ 'bash[cluster-status]' ]
#   end
# end

# if data['leader'] === true
# end
