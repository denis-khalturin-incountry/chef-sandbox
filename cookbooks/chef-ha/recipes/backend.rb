log 'message' do
  message  "packages:\n#{node['qqq']}"
  level    :info
end

log 'message' do
  message  "databag:\n#{data_bag('nodes')}"
  level    :info
end

n = data_bag_item('nodes', 'chef-backend-01')

log 'message' do
  message  "databag:\nid: #{n['id']}; leader: #{n['leader']}; qqq: #{n['qqq']}"
  level    :info
end
