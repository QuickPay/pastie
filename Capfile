load 'deploy'
require 'bundler/capistrano'

set :application, "pastie.pil.dk"
set :user, "pastie"

set :deploy_to, "/dana/data/pastie.pil.dk"
set :copy_exclude, [".hg/*", "spec/*"]
set :unicorn, true

server "locobad.pil.dk", :web, :app, :db

load '/usr/local/etc/Capfile.common'
