# log Chef::JSONCompat.to_json_pretty(node)

log "#{node['package']['backend']['deb']}, #{node['package']['backend']['sum']}"
log "#{node['package']['frontend']['deb']}, #{node['package']['frontend']['sum']}"

leader = {}
data = data_bag_item('frontend', node[:hostname])

ruby_block 'wait-chef-frontend-config' do
  block do
    true until ::File.exists?("/tmp/chef-#{node[:hostname]}.rb")
  end
end

ruby_block 'private-chef-secrets' do
  block do
    true until ::File.exists?("/tmp/chef-private-chef-secrets.json")
  end

  only_if { !data[:leader] }
end

ruby_block 'migration-level' do
  block do
    true until ::File.exists?("/tmp/chef-migration-level")
  end

  only_if { !data[:leader] }
end

directory '/var/opt/opscode/upgrades/' do
  recursive true
  action :create

  only_if { !data[:leader] }
end

file '/var/opt/opscode/bootstrapped' do
  action :create

  only_if { !data[:leader] }
end

remote_file "copy-chef-server.rb" do 
  path "/etc/opscode/chef-server.rb" 
  source "file:///tmp/chef-#{node[:hostname]}.rb"
end

remote_file "copy-chef-server.rb" do 
  path "/etc/opscode/private-chef-secrets.json" 
  source "file:///tmp/chef-private-chef-secrets.json"
  only_if { !data[:leader] }
end

remote_file "copy-migration-level" do 
  path "/var/opt/opscode/upgrades/migration-level" 
  source "file:///tmp/chef-migration-level"
  only_if { !data[:leader] }
end

bash 'status' do
  code 'chef-server-ctl status | grep Services'
  ignore_failure :quiet
  returns 1
end

bash 'chef-server-reconfigure' do
  code 'chef-server-ctl reconfigure --chef-license=accept'

  action :nothing
  subscribes :run, [ 'bash[status]' ]
end

data_bag('frontend').each do |host|
  front = data_bag_item('frontend', host)

  if !!data[:leader]
    bash 'copy-files-to-follower' do
      code <<-EOF
        scp -o StrictHostKeychecking=no /var/opt/opscode/upgrades/migration-level #{front[:ip]}:/tmp/chef-migration-level
        scp -o StrictHostKeychecking=no /etc/opscode/private-chef-secrets.json #{front[:ip]}:/tmp/chef-private-chef-secrets.json
      EOF

      only_if { !front[:leader] } 
    end
  end
end
