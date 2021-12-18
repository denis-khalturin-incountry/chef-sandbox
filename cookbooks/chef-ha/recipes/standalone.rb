deb = File.basename(node[:package][:frontend][:deb])

remote_file "/opt/#{deb}" do
  source node[:package][:frontend][:deb]
  checksum node[:package][:frontend][:sum]
  show_progress true
  action :create
end

dpkg_package "/opt/#{deb}"

host = node[:standalone]

log host
