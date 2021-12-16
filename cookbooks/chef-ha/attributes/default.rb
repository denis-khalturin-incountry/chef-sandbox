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

default['sshkey']['pub'] = <<-EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRESEYqC0AF0albVYFg3cdkHT+saDVv1sgYh0CnLxnBNJPqzt8iDLooWoUCKKccRvv7ekljwtHcCX3tejlRlrEhlhM/7cu7gNdOiBavunX4gdIxAwLcjTXdm+o2pphPkwUrpDrHLpXwWX96mFRH8T8FeXRZ2vkIccWEd+ENTbPW2Wzx4etgmfXkkwykjXDSxVIBme9Jg+fLDt3sxglAx9mAzhHva8uFdlIxOK0t0to7khs8QzFt696v9BeJwIfFm5B0qWtYTZoHiRsyqIDsJ91wSEHX8uqvdeBvWx1ZaEW7NEWXXtIoT6sRZtdHmWfoCFPYGKgRUdcrZz0+bFiwYYgCrucl9xEMnMK/fwtgIClyPLebwMS8tT2Ga5HGzqdUdN6WYnUeFZJb/ONrf+DrpYv/NgNV6xB0p4jI0J6976g6RfhHGqqLUJjopRnNV//6THDaeq+2WJLGH5LVNUUQLT0QLZeSW8qks6XC68C5OSTzKDoiLILaHO+ZPx9IKZbZ5k=
EOF

default['sshkey']['key'] = <<-EOF
-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
EOF
