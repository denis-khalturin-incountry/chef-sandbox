# log Chef::JSONCompat.to_json_pretty(node)

deb = File.basename(node[:package][:frontend][:deb])

remote_file "/opt/#{deb}" do
  source node[:package][:frontend][:deb]
  checksum node[:package][:frontend][:sum]
  show_progress true
  action :create
end

dpkg_package "/opt/#{deb}"

leader = {}
host = node[:frontend][node[:hostname]]

ruby_block 'wait-chef-frontend-config' do
  block do
    sleep 5 until ::File.exists?("/opt/chef-#{node[:hostname]}.rb")
  end
end

ruby_block 'private-chef-secrets' do
  block do
    sleep 5 until ::File.exists?("/opt/chef-private-chef-secrets.json")
  end

  only_if { !host[:leader] }
end

ruby_block 'migration-level' do
  block do
    sleep 5 until ::File.exists?("/opt/chef-migration-level")
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
  source "file:///opt/chef-#{node[:hostname]}.rb"
end

remote_file "copy-private-chef-secrets.json" do 
  path "/etc/opscode/private-chef-secrets.json" 
  source "file:///opt/chef-private-chef-secrets.json"
  only_if { !host[:leader] }
end

remote_file "copy-migration-level" do 
  path "/var/opt/opscode/upgrades/migration-level" 
  source "file:///opt/chef-migration-level"
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
  subscribes :run, [ 'bash[status]' ], :immediately
end

node[:frontend].each do |hostname, data|
  if !!host[:leader]
    bash 'copy-files-to-follower' do
      code <<-EOF
        scp -o StrictHostKeychecking=no /var/opt/opscode/upgrades/migration-level #{data[:ip]}:/opt/chef-migration-level
        scp -o StrictHostKeychecking=no /etc/opscode/private-chef-secrets.json #{data[:ip]}:/opt/chef-private-chef-secrets.json
      EOF

      only_if { !data[:leader] } 
    end
  end
end
