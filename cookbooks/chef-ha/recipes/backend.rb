log 'message' do
  message  "packages:\n#{node['ipaddress']}"
  level    :info
end

log 'message' do
  message  "databag:\nBACKEND:#{data_bag('backend')}\nFRONTEND:#{data_bag('frontend')}"
  level    :info
end

data = data_bag_item('backend', 'chef-backend-01')

log 'message' do
  message  "databag:\n#{data['leader'] === true}; #{data['ip']}"
  level    :info
end

file '/etc/chef-backend/chef-backend.rb' do
  content "publish_address '#{node['ipaddress']}'"
end

bash 'create-cluster' do
  code 'chef-backend-ctl create-cluster --accept-license'
  only_if { data['leader'] === true }
end

data_bag('backend').each do |host|
  log 'message' do
    message  "HOST: #{host}"
    level    :info
  end

  only_if { data['leader'] === true }
end
