# log Chef::JSONCompat.to_json_pretty(node)

leader = {}
host = node['frontend'][node[:hostname]]

ruby_block 'wait-chef-frontend-config' do
  block do
    sleep 5 until ::File.exists?("/tmp/chef-#{node[:hostname]}.rb")
  end
end

ruby_block 'private-chef-secrets' do
  block do
    sleep 5 until ::File.exists?("/tmp/chef-private-chef-secrets.json")
  end

  only_if { !host[:leader] }
end

ruby_block 'migration-level' do
  block do
    sleep 5 until ::File.exists?("/tmp/chef-migration-level")
  end

  only_if { !host[:leader] }
end

directory '/var/opt/opscode/upgrades/' do
  recursive true
  action :create

  only_if { !host[:leader] }
end

file '/var/opt/opscode/bootstrapped' do
  action :create

  only_if { !host[:leader] }
end

remote_file "copy-chef-server.rb" do 
  path "/etc/opscode/chef-server.rb" 
  source "file:///tmp/chef-#{node[:hostname]}.rb"
end

remote_file "copy-chef-server.rb" do 
  path "/etc/opscode/private-chef-secrets.json" 
  source "file:///tmp/chef-private-chef-secrets.json"
  only_if { !host[:leader] }
end

remote_file "copy-migration-level" do 
  path "/var/opt/opscode/upgrades/migration-level" 
  source "file:///tmp/chef-migration-level"
  only_if { !host[:leader] }
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

node['frontend'].each do |hostname, data|
  if !!host[:leader]
    bash 'copy-files-to-follower' do
      code <<-EOF
        scp -o StrictHostKeychecking=no /var/opt/opscode/upgrades/migration-level #{data[:ip]}:/tmp/chef-migration-level
        scp -o StrictHostKeychecking=no /etc/opscode/private-chef-secrets.json #{data[:ip]}:/tmp/chef-private-chef-secrets.json
      EOF

      only_if { !data[:leader] } 
    end
  end
end
