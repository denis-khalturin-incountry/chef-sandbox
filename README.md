## Preparing

Create an ssh key and deploy them to your hosts

```shell
# will be create file - cookbooks/ssh/attributes/default.rb
chef-solo -c solo.rb -o 'recipe[ssh::gen]'

# copying created ssh key to your hosts
awk -F "'" '/ip/{ORS=","; print $8}' cookbooks/chef-ha/attributes/default.rb | xargs -I {} chef-run --cookbook-repo-paths cookbooks {} --user ubuntu --sudo ssh::copy
```

### Deployment

First, deploy the backend servers

```shell
awk -F "'" '/backend.*ip/{ORS=","; print $8}' cookbooks/chef-ha/attributes/default.rb | xargs -I {} chef-run --cookbook-repo-paths cookbooks {} --user ubuntu --sudo chef-ha::backend
```

Finally, deploy the frontend servers

```shell
awk -F "'" '/frontend.*ip/{ORS=","; print $8}' cookbooks/chef-ha/attributes/default.rb | xargs -I {} chef-run --cookbook-repo-paths cookbooks {} --user ubuntu --sudo chef-ha::frontend
```
