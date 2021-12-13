#!/bin/bash

echo -e "y\n" | ssh-keygen -t rsa -f /tmp/.chef-sshkey -q -N "" > /dev/null

SSH_KEY=$(cat /tmp/.chef-sshkey)
SSH_KEY_PUB=$(cat /tmp/.chef-sshkey.pub)

find nodes -type f -name "*.json" | while read json; do
    ip=$(basename ${json} ".json")

    jq -r '.hostname' ${json} | grep -q front && continue

    # echo ${json}
    # echo ${ip}
    cat <<EOF | ssh ${ip} -l ubuntu \
        -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeychecking=no \
        /bin/bash
cat >> ~/.ssh/id_rsa <<KEY
${SSH_KEY} 
KEY
cat >> ~/.ssh/authorized_keys <<KEY
${SSH_KEY_PUB} 
KEY
command -v chef-solo || curl https://www.chef.io/chef/install.sh -L | sudo bash
rm -rf chef-sandbox
git clone https://github.com/denis-khalturin-incountry/chef-sandbox
cd chef-sandbox
chef-solo --chef-license accept -c solo.rb -j ${json} 
EOF
    break
done
