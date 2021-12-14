leader = {}
data = data_bag_item('frontend', node[:hostname])

ruby_block 'wait-chef-frontend-config' do
  block do
    true until ::File.exists?("/tmp/chef-#{node[:hostname]}.rb")
  end
end
