load 'deploy'
require 'bundler/capistrano'

set :application, "pastie"
set :user, "pastie"

set :deploy_to, "/usr/local/www/pastie"
set :copy_exclude, [".hg/*", "spec/*"]
set :unicorn, true

server ENV['server'], :web, :app, :db

load '/usr/local/etc/Capfile.common'

after "deploy:update_code" do
  run "ln -s /usr/local/www/pastie/shared/documents #{latest_release}/public/documents"
end
