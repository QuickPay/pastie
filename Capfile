load 'deploy'
require 'bundler/capistrano'

set :application, "scruffy"
set :user, "scruffy"

set :repository, 'ssh://hg@rcs.pil.dk/pil/pastie.pil.dk' # FIXME: set by variable from 'deploy'-helper
set :scm, :mercurial

set :deploy_to, "/dana/data/pastie.pil.dk"
set :deploy_via, :copy
set :copy_cache, "/Users/kenneth/.deploy/cache/scruffy" # FIXME: set by variable from 'deploy'-helper
set :copy_exclude, [".hg/*", "spec/*", "vendor/ruby/*", "vendor/bundle/*", "logs/*", "tmp/*"]
set :bundle_cmd, "env RB_USER_INSTALL=yes bundle"

role :web, "locobad.pil.dk"
#role :web, "vagrant@localhost:2222"

set :rails_env, :production
set :unicorn_binary, "bundle exec unicorn"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "kill `cat #{unicorn_pid}`"
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end
