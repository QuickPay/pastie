load 'deploy'
require 'bundler/capistrano'

set :application, "scruffy"
set :user, "scruffy"

set :deploy_to, "/dana/data/pastie.pil.dk"
set :copy_exclude, [".hg/*", "spec/*"]

server "locobad.pil.dk", :web, :app, :db

load '/usr/local/etc/Capfile.common'
