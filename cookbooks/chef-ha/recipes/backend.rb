deb = File.basename(node['package']['backend']['deb'])

remote_file "/tmp/#{deb}" do
  source node['package']['backend']['deb']
  checksum node['package']['backend']['sum']
  show_progress true
  action :create
end

dpkg_package "/tmp/#{deb}"

leader = {}
host = node['backend'][node[:hostname]]

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

  only_if { !!host[:leader] }
end

ruby_block 'wait-chef-backend-secrets' do
  block do
    sleep 5 until ::File.exists?('/etc/chef-backend/chef-backend-secrets.json')
  end

  action :nothing
  subscribes :run, [ 'bash[cluster-create]' ]

  only_if { !!host[:leader] }
end

# node['backend'].each do |hostname, data|
#   if !!host[:leader]
#     bash 'chef-backend-secrets' do
#       code "scp -o StrictHostKeychecking=no /etc/chef-backend/chef-backend-secrets.json #{data[:ip]}:/tmp/"

#       only_if { !data[:leader] }
#     end
#   else
#     if !!data[:leader]
#       leader = data
#       break
#     end
#   end
# end

# node['frontend'].each do |hostname, data|
#   if !!host[:leader]
#     bash 'chef-frontend-config' do
#       code <<-EOF
#         chef-backend-ctl gen-server-config #{hostname} -f /tmp/chef-#{hostname}.rb
#         scp -o StrictHostKeychecking=no /tmp/chef-#{hostname}.rb #{data[:ip]}:/tmp/
#       EOF
#     end
#   end
# end

# ruby_block 'wait-chef-backend-secrets' do
#   block do
#     sleep 5 until ::File.exists?('/tmp/chef-backend-secrets.json')
#   end

#   only_if { !host[:leader] }
# end

# bash 'join-cluster' do
#   code "chef-backend-ctl join-cluster #{leader[:ip]} -s /tmp/chef-backend-secrets.json --accept-license --yes"

#   action :nothing
#   subscribes :run, [ 'bash[cluster-status]' ]

#   only_if { !host[:leader] }
# end
