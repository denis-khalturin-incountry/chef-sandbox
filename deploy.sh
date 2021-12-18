#!/bin/bash

set -x

ip=10.42.106.171

cat <<EOF | ssh ${ip} -l ubuntu \
    -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeychecking=no \
    sudo /bin/bash
command -v chef-solo > /dev/null || curl https://www.chef.io/chef/install.sh -L | sudo bash
rm -rf chef-sandbox
git clone https://github.com/denis-khalturin-incountry/chef-sandbox
cd chef-sandbox
chef-solo --chef-license accept -c solo.rb -o 'recipe[chef-ha::backend]'
# chef-solo --chef-license accept -c solo.rb -o 'recipe[chef-ha::frontend]'
EOF
