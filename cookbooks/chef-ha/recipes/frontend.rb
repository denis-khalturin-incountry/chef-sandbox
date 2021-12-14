leader = {}
data = data_bag_item('frontend', node[:hostname])

ruby_block 'wait-chef-frontend-config' do
  block do
    true until ::File.exists?("/tmp/chef-#{node[:hostname]}.rb")
  end
end

file "/etc/opscode/chef-server.rb`" do
  content ::File.open("/tmp/chef-#{node[:hostname]}.rb").read
  action :create
end

bash 'chef-server-reconfigure' do
  code 'chef-server-ctl reconfigure'
end
