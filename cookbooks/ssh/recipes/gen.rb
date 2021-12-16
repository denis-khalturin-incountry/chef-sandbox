chef_gem 'sshkey'

require 'sshkey'

sshkey = SSHKey.generate(type: 'RSA')

file "#{Chef::Config[:cookbook_path]}/ssh/attributes/default.rb" do
  content <<-EOF
default['ssh']['pub'] = <<-KEY
#{sshkey.ssh_public_key}
KEY
default['ssh']['key'] = <<-KEY
#{sshkey.private_key}
KEY
EOF
end
