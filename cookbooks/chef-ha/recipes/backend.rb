log 'message' do
  message  "packages:\n#{node['package']}"
  level    :info
end

log 'message' do
  message  "databag:\nBACKEND:#{data_bag('backend')}\nFRONTEND:#{data_bag('frontend')}"
  level    :info
end

data = data_bag_item('backend', 'chef-backend-02')

log 'message' do
  message  "databag:\n#{data['leader']}; #{data['ip']}"
  level    :info
end
