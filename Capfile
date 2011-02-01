load 'deploy'
require 'bundler/capistrano'

set :application, "scruffy"
set :user, "scruffy"

set :deploy_to, "/dana/data/pastie.pil.dk"
set :copy_exclude, [".hg/*", "spec/*"]

server "locobad.pil.dk", :web, :app, :db


# --- DEFAULTS ---

set :use_sudo, false
set :normalize_asset_timestamps, false
set :group_writable, false
set :app_env, :production

set :unicorn_binary, "bundle exec unicorn"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"
set :bundle_cmd, "env RB_USER_INSTALL=yes bundle"

namespace :deploy do
  desc "Start Unicorn"
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && #{unicorn_binary} -c #{unicorn_config} -E #{app_env} -D"
  end

  desc "Stop Unicorn"
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "kill `cat #{unicorn_pid}`"
  end

  desc "Stop Unicorn gracefully (when done processing requests already accepted)"
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end

  desc "Restart Unicorn gracefully"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end
end
