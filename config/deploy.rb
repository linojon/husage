set :application, "husage"
set :domain, "parkerhill.railsplayground.net"
set :user, "parkerhi"

set :repository,  "git://github.com/linoj/husage.git"
set :scm, :git
#set :scm_username, user
#set :runner, user
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
set :deploy_for, 'passenger'
#set :deploy_for, 'fcgi'
#set :deploy_for, 'mongrel'
set :public_html, 'shared'
#set :public_html, 'single'

#set :database, 'sqlite3'
set :database, 'mysql'

