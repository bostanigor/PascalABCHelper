server '167.172.181.192', user: 'deploy', roles: %w{app db web}
set :deploy_to, "/home/deploy/pascal_abc_helper"

set :branch, 'master'