remote_file '/tmp/1.deb' do
  source node['package']['deb']
  checksum node['package']['sum']
  show_progress true
  action :create
end
