load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'

app_path = "/home/#{user}/public_html/#{application}"

namespace :deploy do
  task :start, :roles => :app do
  	run "rm -rf #{app_path};ln -s #{current_path}/public #{app_path}"
  end

  task :restart, :roles => :app do
		run "touch #{current_path}/tmp/restart.txt"
  end

	task :make_online, :roles => :app do
    run "cd #{release_path}/public && cp -f online.htaccess .htaccess && chmod 644 .htaccess"
        
    # config on server
    run "cd #{release_path}/config              && cp -f database.yml.online database.yml"
    run "cd #{release_path}/config              && cp -f environment.rb.online environment.rb"
    run "cd #{release_path}/config/environments && cp -f production.rb.online production.rb"
    run "cd #{release_path}/config/environments && cp -f test.rb.online test.rb"
    run "cd #{release_path}/config/environments && cp -f cucumber.rb.online cucumber.rb"
    
    if database == 'sqlite3'
      # NOTE: or, can change this to a different shared dir if also set in database.yml
      run "cd #{release_path} && ln -s #{shared_path}/sqlite"
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
