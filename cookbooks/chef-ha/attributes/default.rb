default['package']['backend']['deb'] = 'https://packages.chef.io/files/stable/chef-backend/2.2.0/ubuntu/18.04/chef-backend_2.2.0-1_amd64.deb'
default['package']['backend']['sum'] = '7da51b509c93f8642bb46584a9eba7c38220fafc9a285b224ad22a5bd2e13efa'

default['package']['frontend']['deb'] = 'https://packages.chef.io/files/stable/chef-server/14.11.15/ubuntu/20.04/chef-server-core_14.11.15-1_amd64.deb'
default['package']['frontend']['sum'] = '2acdbaee2046885103dee271009ff360001b86d304a47abbc4d52bd0215003e2'

default['backend']['chef-backend-01']['leader'] = true
default['backend']['chef-backend-01']['ip'] = '10.42.106.178'
default['backend']['chef-backend-02']['ip'] = '10.42.106.84'
default['backend']['chef-backend-03']['ip'] = '10.42.106.106'

default['frontend']['chef-frontend-01']['leader'] = true
default['frontend']['chef-frontend-01']['ip'] = '10.42.106.11'
default['frontend']['chef-frontend-02']['ip'] = '10.42.106.164'
default['frontend']['chef-frontend-03']['ip'] = '10.42.106.156'
