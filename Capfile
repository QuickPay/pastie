load 'deploy'
require 'bundler/capistrano'

set :application, "pastie"
set :user, "pastie"

set :scm, :git
set :repository, "git@github.com:pildk/pastie.git"
set :branch, "master"
set :deploy_via, :copy
set :deploy_to, "/usr/local/www/pastie"
set :copy_exclude, [".git/*", "spec/*"]
set :unicorn, true

server ENV['server'], :web, :app, :db

set :use_sudo, false
set :normalize_asset_timestamps, false
set :group_writable, false
set :app_env, :production

set :unicorn_binary, "bundle exec unicorn"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"
set :bundle_cmd, "env RB_USER_INSTALL=yes bundle"

if fetch(:unicorn, false)
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
else
  # No-op start/stop by default
  namespace :deploy do
    [:start, :stop, :graceful_stop, :restart].each do |t|
      task t, :roles => :app do ; end
    end
  end
end

after "deploy:update_code" do
  run "ln -s /usr/local/www/pastie/shared/documents #{latest_release}/public/documents"
end
