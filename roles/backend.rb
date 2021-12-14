name "backend"
description "Part of Chef Infra HA"

default_attributes 'package' => {
  'deb' => 'https://packages.chef.io/files/stable/chef-backend/2.2.0/ubuntu/18.04/chef-backend_2.2.0-1_amd64.deb',
  'sum' => '7da51b509c93f8642bb46584a9eba7c38220fafc9a285b224ad22a5bd2e13efa'
}

run_list 'recipe[chef-ha::package]',
         'recipe[chef-ha::backend]'
