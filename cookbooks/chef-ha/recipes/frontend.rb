leader = {}
data = data_bag_item('frontend', node[:hostname])

ruby_block 'wait-chef-frontend-config' do
  block do
    true until ::File.exists?("/tmp/chef-#{node[:hostname]}.rb")
  end
end

remote_file "copy-chef-server.rb" do 
  path "/etc/opscode/chef-server.rb" 
  source "file:///tmp/chef-#{node[:hostname]}.rb"
end

ruby_block 'private-chef-secrets' do
  block do
    true until ::File.exists?("/tmp/chef-private-chef-secrets.json")
  end

  only_if { !data[:leader] } 
end

remote_file "copy-chef-server.rb" do 
  path "/etc/opscode/private-chef-secrets.json" 
  source "file:///tmp/chef-private-chef-secrets.json"
  only_if { !data[:leader] } 
end

bash 'status' do
  code 'chef-server-ctl status | grep Services'
  ignore_failure :quiet
  returns 1
end

bash 'chef-server-reconfigure' do
  code 'chef-server-ctl reconfigure'

  action :nothing
  subscribes :run, [ 'bash[status]' ]
end

data_bag('frontend').each do |host|
  front = data_bag_item('frontend', host)

  if !!data[:leader]
    bash 'private-chef-secrets' do
      code <<-EOF
        scp -o StrictHostKeychecking=no /etc/opscode/private-chef-secrets.json #{front[:ip]}:/tmp/chef-private-chef-secrets.json
      EOF

      only_if { !front[:leader] } 
    end
  end
end
