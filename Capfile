load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'

# set this for target deploy
# (When fcgi, Remember to edit environment.rb for 'production')
DEPLOY_FOR = 'fcgi'
#DEPLOY_FOR = 'mongrel'

DATABASE = 'sqlite3'
#DATABASE = 'mysql'

# the following is ref: http://www.hostingrails.com/forums/wiki_thread/46

# ========================
# For FCGI Apps
# ========================
if DEPLOY_FOR == 'fcgi'

namespace :deploy do

  task :start, :roles => :app do
  	run "rm -rf /home/#{user}/public_html/#{application};ln -s #{current_path}/public /home/#{user}/public_html/#{application}"
  end

  task :restart, :roles => :app do
		run "pkill -9 -u #{user} dispatch.fcgi"
  end
end

end

# ========================
#    For Mongrel Apps
# ========================

# if DEPLOY_FOR == 'mongrel'
# 
# namespace :deploy do
# 
#   task :stop, :roles => :app do
#     run "cd #{current_path} && mongrel_rails stop"
#   end
#   
#   task :start, :roles => :app do
#     # note, if rm/ln doesnt work (current not updated) maybe an ssh session has it as the cwd???
#     run "rm -rf /home/#{user}/public_html;ln -s #{current_path}/public /home/#{user}/public_html"
#     run "cd #{current_path} && mongrel_rails start -e production -p #{mongrel_port} -d"
#   end
# 
#   task :restart, :roles => :app do
#     #run "cd #{current_path} && mongrel_rails restart"
#     run "cd #{current_path} && mongrel_rails stop"
#     # hostingrails loses the mongrel.pid sometimes
#     run "pkill -9 mongrel_rails -u #{user}"
#     run "cd #{current_path} && mongrel_rails start -e production -p #{mongrel_port} -d"
#     run "cd #{current_path} && chmod 755 #{chmod755}"
#   end
# 
# end
# 
# end

# ========================
# For Mongrel Cluster Apps
# ========================

# namespace :deploy do
# 
#   task :start, :roles => :app do
#     run "cd #{current_path} && mongrel_rails cluster::configure -e production -p #{mongrel_port}0 -N #{mongrel_nodes} -c #{current_path} --user #{user} --group #{user}"
#     run "cd #{current_path} && mongrel_rails cluster::start"
#     run "rm -rf /home/#{user}/public_html;ln -s #{current_path}/public /home/#{user}/public_html"
#     run "mkdir -p #{deploy_to}/shared/config"
#     run "mv #{current_path}/config/mongrel_cluster.yml #{deploy_to}/shared/config/mongrel_cluster.yml"
#     run "ln -s #{deploy_to}/shared/config/mongrel_cluster.yml #{current_path}/config/mongrel_cluster.yml"
#   end
# 
#   task :restart, :roles => :app do
#     run "ln -s #{deploy_to}/shared/config/mongrel_cluster.yml #{current_path}/config/mongrel_cluster.yml"
#     run "cd #{current_path} && mongrel_rails cluster::restart"
#     run "cd #{current_path} && chmod 755 #{chmod755}"
#   end
# 
# end

# ========================
# shared for all apps
# ========================
# Cap Notes: current_path, shared_path, release_path

namespace :deploy do
	task :make_online, :roles => :app do

    if DEPLOY_FOR == 'fcgi'
      # for cgi server only
      run "cd #{release_path}/public && cp -f dispatch.rb.online   dispatch.rb"
      run "cd #{release_path}/public && cp -f dispatch.cgi.online  dispatch.cgi"
      run "cd #{release_path}/public && cp -f dispatch.fcgi.online dispatch.fcgi"
      run "cd #{release_path}/public && cp -f online.htaccess      .htaccess"
      
    end
    
    # config on server
    run "cd #{release_path}/config              && cp -f database.yml.online database.yml"
    run "cd #{release_path}/config              && cp -f environment.rb.online environment.rb"
    run "cd #{release_path}/config/environments && cp -f production.rb.online production.rb"
    run "cd #{release_path}/config/environments && cp -f test.rb.online test.rb"
    run "cd #{release_path}/config/environments && cp -f cucumber.rb.online cucumber.rb"
    
    if DATABASE == 'sqlite3'
      # NOTE: or, can change this to a different shared dir if also set in database.yml
      run "cd #{release_path}/db && ln -s #{shared_path}/db/production.sqlite3"
    end

    # # spec on server
    # run "cd #{release_path}/spec && cp -f spec.opts.online spec.opts"
    # run "cd #{release_path} && mkdir private"
    # run "cd #{release_path} && chmod 755 private"
    # #run "cd #{release_path}/private && cp -f #{shared_path}/private.htaccess .htaccess"
    # #run "cd #{release_path}/private && cp -f #{shared_path}/private.htpasswd .htpasswd"    
        
    # # symlink shared file uploads (images, downloads, attachments)
    # run "cd #{release_path} && ln -s #{shared_path}/system/files #{release_path}/files"
    
    run "cd #{release_path} && chmod -R 755 ."
    
  end
end

after "deploy:finalize_update", "deploy:make_online"
