file "/root/.ssh/id_rsa" do
  content node[:ssh][:key]
  mode 0400
end

file "/root/.ssh/authorized_keys" do
  content node[:ssh][:pub]
  mode 0644
end

# log Chef::JSONCompat.to_json_pretty(Chef::Config.to_hash)
