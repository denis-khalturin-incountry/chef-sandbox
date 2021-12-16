chef-solo -c solo.rb -o 'recipe[ssh::gen]'
awk -F "'" '/ip/{NR ","; print $8}' cookbooks/chef-ha/attributes/default.rb | paste -s -d, - | xargs -I {} chef-run --cookbook-repo-paths cookbooks {} --user ubuntu --sudo ssh::copy
