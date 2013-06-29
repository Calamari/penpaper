set :application, "penpaper"
set :repository,  "./"

# Allow entering sudo passwords if needed
# default_run_options[:pty] = true

require "bundler/capistrano"

require 'rvm/capistrano'
set :rvm_ruby_string, 'ruby-2.0.0-p0@penpaper'
set :rvm_type, :user
before 'deploy:setup', 'rvm:create_gemset'

set :local_repository,  "/Users/georg.tavonius/Dropbox/coding/penpaper/.git"
set :repository, "https://github.com/Calamari/penpaper.git"

set :ssh_options, {:forward_agent => true}
set :user, 'calamari'

set :scm, :git
# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :use_sudo, false

server '85.214.144.70', :app, :web, :db, :primary => true
# role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

set :deploy_to, "/var/www/#{application}"
#set :deploy_via, :export
set :keep_releases, 4
# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after 'deploy:setup' do
  deploy.setup_directories
end

after "deploy:update_code", "deploy:migrate"
after "deploy:update_code", "deploy:assets:precompile"
