log 'message' do
  message  "packages:\n#{node['qqq']}"
  level    :info
end

log 'message' do
  message  "databag:\nBACKEND:#{data_bag('backend')}\nFRONTEND:#{data_bag('frontend')}"
  level    :info
end

n = data_bag_item('backend', 'chef-backend-02')

log 'message' do
  message  "databag:\nid: #{n['id']}; leader: #{n['leader'] === true}; qqq: #{n['qqq']}"
  level    :info
end
