log 'message' do
  message  "packages:\n#{node['hostname']}"
  level    :info
end

log 'message' do
  message  "databag:\nBACKEND:#{data_bag('backend')}\nFRONTEND:#{data_bag('frontend')}"
  level    :info
end

data = data_bag_item('backend', node['hostname'])
leader = {}

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
  ignore_failure :quiet
  returns 1

  only_if { !!data['leader'] }
end

bash 'cluster-create' do
  code 'chef-backend-ctl create-cluster --accept-license --yes'

  action :nothing
  subscribes :run, [ 'bash[cluster-status]' ]

  only_if { !!data['leader'] }
end

data_bag('backend').each do |host|
  back = data_bag_item('backend', host)

  if !!data['leader']
    bash 'chef-backend-secrets' do
      code "scp -o StrictHostKeychecking=no /etc/chef-backend/chef-backend-secrets.json #{back['ip']}:/tmp/chef-backend-secrets.json"

      only_if { !back['leader'] } 
    end
  else
    if !!back['leader']
      leader = back
      break
    end
  end
end

log 'message' do
  message  "DATA 1: #{leader['ip']}: #{leader['leader']}"
  level    :info
end

# bash 'cluster-create' do
#   code 'chef-backend-ctl join-cluster <IP_BE1> -s /tmp/chef-backend-secrets.json'

#   only_if { !data['leader'] }
# end
