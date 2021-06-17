# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "pascal_abc_helper"
set :repo_url, "git@github.com:bostanigor/PascalABCHelper.git"
set :rvm_type, :user
set :rvm_custom_path, '/usr/share/rvm'

set :rvm_ruby_version, '3.0.0'
# set :init_system, :systemd
# set :use_sudo, true

append :linked_files, "config/database.yml", "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"

set :conditionally_migrate, true

set :passenger_restart_with_touch, true

namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        unless test("[ -f #{shared_path}/config/master.key ]")
          upload! 'config/master.key', "#{shared_path}/config/master.key"
        end
      end
    end
  end
end
