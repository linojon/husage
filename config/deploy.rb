set :application, "hughes" #"husage"
set :domain, "rails.parkerhill.com"
set :user, "parkerhi"

set :repository,  "#{user}@#{domain}:/home/#{user}/git/#{application}"
#set :repository,  "/home/#{user}/git/#{application}"
set :scm, :git
set :scm_username, user
set :runner, user
set :use_sudo, false
set :branch, "master"
set :deploy_via, :checkout
set :git_shallow_clone, 1
set :deploy_to, "/home/#{user}/apps/#{application}"
default_run_options[:pty] = true

role :web, domain
role :app, domain
role :db, domain, :primary => true

# set this for target deploy
# (When fcgi, Remember to edit environment.rb for 'production')
set :deploy_for, 'fcgi'
#set :deploy_for, 'mongrel'

#set :database, 'sqlite3'
set :database, 'mysql'
