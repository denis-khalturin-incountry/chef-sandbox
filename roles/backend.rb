name "backend"
description "Part of Chef Infra HA"

default_attributes 'package' => {
  'deb' => 'https://packages.chef.io/files/stable/chef-server/14.11.15/ubuntu/20.04/chef-server-core_14.11.15-1_amd64.deb',
  'sum' => '2acdbaee2046885103dee271009ff360001b86d304a47abbc4d52bd0215003e2'
}

run_list 'recipe[chef-ha::package]',
         'recipe[chef-ha::backend]'
