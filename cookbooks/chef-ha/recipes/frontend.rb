leader = {}
data = data_bag_item('frontend', node[:hostname])

ruby_block 'wait-chef-frontend-config' do
  block do
    true until ::File.exists?("/tmp/chef-#{node[:hostname]}.rb")
  end
end

file "/etc/opscode/chef-server.rb" do
  content lazy { ::File.open("/tmp/chef-#{node[:hostname]}.rb").read }
  action :create
end

# if !data[:leader]
#   ruby_block 'private-chef-secrets' do
#     block do
#       true until ::File.exists?("/tmp/chef-private-chef-secrets.json")
#     end
#   end

#   file "/etc/opscode/private-chef-secrets.json" do
#     content ::File.open("/tmp/chef-private-chef-secrets.json").read
#     action :create
#     only_if { !data[:leader] } 
#   end
# end

bash 'chef-server-reconfigure' do
  code 'chef-server-ctl reconfigure'
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
