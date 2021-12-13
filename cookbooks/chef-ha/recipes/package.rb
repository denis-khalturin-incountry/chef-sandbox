deb = File.basename(node['package']['deb'])

remote_file "/tmp/#{deb}" do
  source node['package']['deb']
  checksum node['package']['sum']
  show_progress true
  action :create
end
