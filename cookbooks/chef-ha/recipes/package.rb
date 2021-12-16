# log Chef::JSONCompat.to_json_pretty(node)

node['backend'].each do |host, data|
  log "#{host}; #{data}"
end
