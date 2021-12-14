log 'message' do
  message  "packages:\n#{node[:hostname]}"
  level    :info
end

log 'message' do
  message  "databag:\nBACKEND:#{data_bag('backend')}\nFRONTEND:#{data_bag('frontend')}"
  level    :info
end

data = data_bag_item('backend', node[:hostname])
leader = {}

log 'message' do
  message  "databag:\n#{data[:leader]}; #{data[:leader] === true}; #{data[:ip]}"
  level    :info
end

directory '/etc/chef-backend' do
  action :create
end

file '/etc/chef-backend/chef-backend.rb' do
  content "publish_address '#{node[:ipaddress]}'"
end

bash 'cluster-status' do
  code 'chef-backend-ctl cluster-status'
  ignore_failure :quiet
  returns 1
end

bash 'cluster-create' do
  code 'chef-backend-ctl create-cluster --accept-license --yes'

  action :nothing
  subscribes :run, [ 'bash[cluster-status]' ]

  only_if { !!data[:leader] }
end

data_bag('backend').each do |host|
  back = data_bag_item('backend', host)

  if !!data[:leader]
    bash 'chef-backend-secrets' do
      code "scp -o StrictHostKeychecking=no /etc/chef-backend/chef-backend-secrets.json #{back[:ip]}:/tmp/"

      only_if { !back[:leader] } 
    end
  else
    if !!back[:leader]
      leader = back
      break
    end
  end
end

data_bag('frontend').each do |host|
  front = data_bag_item('frontend', host)

  if !!data[:leader]
    bash 'chef-frontend-config' do
      code <<-EOF
        chef-backend-ctl gen-server-config #{host} -f /tmp/chef-#{host}.rb
        scp -o StrictHostKeychecking=no /tmp/chef-#{host}.rb #{front[:ip]}:/tmp/
      EOF
    end
  end
end

ruby_block 'wait-chef-backend-secrets' do
  block do
    true until ::File.exists?('/tmp/chef-backend-secrets.json')
  end

  only_if { !data[:leader] }
end

bash 'cluster-create' do
  code "chef-backend-ctl join-cluster #{leader[:ip]} -s /tmp/chef-backend-secrets.json --accept-license --yes"

  action :nothing
  subscribes :run, [ 'bash[cluster-status]' ]

  only_if { !data[:leader] }
end
