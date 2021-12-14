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

execute 'cluster-status' do
  command 'chef-backend-ctl cluster-status >/dev/null 2>&1 && echo 1 || echo 2'
  # returns [0, 1]

  only_if { data['leader'] != true }
end

log 'message' do
  message  "TEST"
  level    :info
  notifies :run, 'execute[cluster-status]'
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
