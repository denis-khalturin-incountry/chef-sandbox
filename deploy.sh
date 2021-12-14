#!/bin/bash

test ! -f /tmp/.chef-sshkey && echo -e "y\n" | ssh-keygen -f /tmp/.chef-sshkey -q -N "" > /dev/null

SSH_KEY=$(cat /tmp/.chef-sshkey)
SSH_KEY_PUB=$(cat /tmp/.chef-sshkey.pub)

find data_bags -type f -name "*.json" | while read data_bag; do
    json_attribs="nodes/$(basename ${data_bag})"
    ip=$(jq -r '.ip' ${data_bag})

    echo -e "data bag:\t${data_bag}\njson attr:\t${json_attribs}\nip:\t\t${ip}"
    cat <<EOF | ssh ${ip} -l ubuntu \
        -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeychecking=no \
        /bin/bash
install -m 400 <(cat <<KEY
${SSH_KEY}
KEY
) /root/.ssh/id_rsa
cat <<KEY | sudo tee /root/.ssh/id_rsa > /dev/null
${SSH_KEY}
KEY
cat <<KEY | sudo tee -a /root/.ssh/authorized_keys > /dev/null
${SSH_KEY_PUB}
KEY
# command -v chef-solo > /dev/null || curl https://www.chef.io/chef/install.sh -L | sudo bash
# sudo rm -rf chef-sandbox
# git clone https://github.com/denis-khalturin-incountry/chef-sandbox
# cd chef-sandbox
# sudo chef-solo --chef-license accept -c solo.rb -j ${json_attribs}
EOF
done
