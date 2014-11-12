set :default_stage, 'staging'


require 'capistrano/ext/multistage'
## Generated with 'brightbox-capify' on 2014-10-28 16:54:41 +0000
gem 'brightbox', '>=2.3.9'
require 'brightbox/recipes'
require 'brightbox/passenger'

set :generate_webserver_config, false


require 'rvm/capistrano'
set :rvm_ruby_string, '2.1.2'

ssh_options[:forward_agent] = true



# The name of your application.  Used for deployment directory and filenames
# and Apache configs. Should be unique on the Brightbox
set :application, "ppe-reader"

set(:deploy_to) { File.join("", "home", user, application) }


# Primary domain name of your application. Used in the Apache configs
#set :domain, "ec2-54-232-144-5.sa-east-1.compute.amazonaws.com"

## List of servers
#server "ec2-54-232-144-5.sa-east-1.compute.amazonaws.com", :app, :web, :db, :primary => true

# Target directory for the application on the web and app servers.
#set(:deploy_to) { File.join("", "home", user, application) }

# URL of your source repository. By default this will just upload
# the local directory.  You should probably change this if you use
# another repository, like git or subversion.

set :repository,  "git@github.com:unepwcmc/protected-planet-consumer.git"
set :scm, :git
set :scm_username, "unepwcmc-read"
set :deploy_via, :remote_cache
set :copy_exclude, [ '.git' ]
set :branch, "master"

### Other options you can set ###
# Comma separated list of additional domains for Apache
# set :domain_aliases, "www.example.com,dev.example.com"

## Dependencies
# Set the commands and gems that your application requires. e.g.
# depend :remote, :gem, "will_paginate", ">=2.2.2"
# depend :remote, :command, "brightbox"
#
# If you're using Bundler, then you don't need to specify your
# gems here as well as there (and the bundler gem is installed for
# you automatically). If you're not using bundler, uncomment the
# following line to explicitly disable it
# set :bundle_disable, true
# 
# Gem with a source (such as github)
# depend :remote, :gem, "tmm1-amqp", ">=0.6.0", :source => "http://gems.github.com"
# 
# Specify your specific Rails version if it is not vendored
# depend :remote, :gem, "rails", "=2.2.2"
#
# Set the apt packages your application or gems require. e.g.
# depend :remote, :apt, "libxml2-dev"

## Local Shared Area
# These are the list of files and directories that you want
# to share between the releases of your application on a particular
# server. It uses the same shared area as the log files.
#
# NOTE: local areas trump global areas, allowing you to have some
# servers using local assets if required.
#
# So if you have an 'upload' directory in public, add 'public/upload'
# to the :local_shared_dirs array.
# If you want to share the database.yml add 'config/database.yml'
# to the :local_shared_files array.
#
# The shared area is prepared with 'deploy:setup' and all the shared
# items are symlinked in when the code is updated.
# set :local_shared_dirs, %w(public/upload)
# set :local_shared_files, %w(config/database.yml)

## Global Shared Area
# These are the list of files and directories that you want
# to share between all releases of your application across all servers.
# For it to work you need a directory on a network file server shared
# between all your servers. Specify the path to the root of that area
# in :global_shared_path. Defaults to the same value as :shared_path.
# set :global_shared_path, "/srv/share/myapp"
#
# NOTE: local areas trump global areas, allowing you to have some
# servers using local assets if required.
#
# Beyond that it is the same as the local shared area.
# So if you have an 'upload' directory in public, add 'public/upload'
# to the :global_shared_dirs array.
# If you want to share the database.yml add 'config/database.yml'
# to the :global_shared_files array.
#
# The shared area is prepared with 'deploy:setup' and all the shared
# items are symlinked in when the code is updated.
# set :global_shared_dirs, %w(public/upload)
# set :global_shared_files, %w(config/database.yml)

# SSL Certificates. If you specify an SSL certificate name then
# the gem will create an 'https' configuration for this application
# TODO: Upload and install the keys on the server
# set :ssl_certificate, "/path/to/certificate/for/my_app.crt"
# set :ssl_key, "/path/to/key/for/my_app.key
# or
# set :ssl_certificate, "name_of_installed_certificate"

## Static asset caching.
# By default static assets served directly by the web server are
# cached by the client web browser for 10 years, and cache invalidation
# of static assets is handled by the Rails helpers using asset
# timestamping.
# You may need to adjust this value if you have hard coded static
# assets, or other special cache requirements. The value is in seconds.
# set :max_age, 315360000

# SSH options. The forward agent option is used so that loopback logins
# with keys work properly
# ssh_options[:forward_agent] = true

# Forces a Pty so that svn+ssh repository access will work. You
# don't need this if you are using a different SCM system. Note that
# ptys stop shell startup scripts from running.
default_run_options[:pty] = true

## Logrotation
# Where the logs are stored. Defaults to <shared_path>/log
# set :log_dir, "central/log/path"
# The size at which to rotate a log. e.g 1G, 100M, 5M. Defaults to 100M
# set :log_max_size, "100M"
# How many old compressed logs to keep. Defaults to 10
# set :log_keep, "10"

## Version Control System
# Which version control system. Defaults to subversion if there is
# no 'set :scm' command.
# set :scm, :git
# set :scm_username, "rails"
# set :scm_password, "mysecret"
# or be explicit
# set :scm, :subversion

## Deployment settings
# The brightbox gem deploys as the user 'rails' by default and
# into the 'production' environment. You can change these as required.
# set :user, "rails"
# set :rails_env, :production

## Command running settings
# use_sudo is switched off by default so that commands are run
# directly as 'user' by the run command. If you switch on sudo
# make sure you set the :runner variable - which is the user the
# capistrano default tasks use to execute commands.
# NOTE: This just affects the default recipes unless you use the
# 'try_sudo' command to run your commands. The 'try_sudo' command
# has been deprecated in favour of 'run "#{sudo} <command>"' syntax.
# set :use_sudo, false
# set :runner, user## Passenger Configuration
# Set the method of restarting passenger
# :soft is the default and just touches tmp/restart.txt as normal.
# :hard forcibly kills running instances, rarely needed now but used
# to be necessary with older versions of passenger
# set :passenger_restart_strategy, :soft

set :local_shared_files, %w(config/database.yml .env)

task :setup_production_database_configuration do
  the_host = Capistrano::CLI.ui.ask("Database IP address: ")
  database_name = Capistrano::CLI.ui.ask("Database name: ")
  database_user = Capistrano::CLI.ui.ask("Database username: ")
  pg_password = Capistrano::CLI.password_prompt("Database user password: ")

  require 'yaml'

  spec = {
    "#{rails_env}" => {
      "adapter" => "postgresql",
      "database" => database_name,
      "username" => database_user,
      "host" => the_host,
      "password" => pg_password
    }
  }

  run "mkdir -p #{shared_path}/config"
  put(spec.to_yaml, "#{shared_path}/config/database.yml")
end

task :setup_ec2 do
  aws_access_key = Capistrano::CLI.ui.ask("AWS_ACCESS_KEY_ID: ")
  aws_secret_access_key = Capistrano::CLI.ui.ask("AWS_SECRET_ACCESS_KEY: ")

require 'yaml'

  spec = {
    "AWS_ACCESS_KEY_ID:" => aws_access_key,
    "AWS_SECRET_ACCESS_KEY:" => aws_secret_access_key
    }
  }

  run "mkdir -p #{shared_path}/config"
  put(spec.to_yaml, "#{shared_path}/config/.env")
end


desc "Links the configuration file"
  task :link_configuration_file do
    run "ln -nsf #{shared_path}/config/.env #{latest_release}/.env"
  end
end


after "deploy:setup", :setup_production_database_configuration
after "deploy:setup", :setup_ec2
after "deploy:setup", :link_configuration_file

default_run_options[:pty] = true

desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
end
