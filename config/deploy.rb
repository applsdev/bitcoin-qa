require 'bundler/capistrano'

set :default_env, 'production'
set :rails_env, ENV['rails_env'] || ENV['RAILS_ENV'] || default_env

django = "django.webflows.fr"

set :application, "bitcoin-qa"
set :repository,  "git@github.com:davout/bitcoin-qa.git"

set :scm, :git
set :deploy_to, "~/qa.bitcoin-central.net"

set :use_sudo, false

set :user, "rails"
set :scm_passphrase, Capistrano::CLI.password_prompt("Rails user password on django : ")

set :branch, "master"

role :web, django
role :app, django
role :db,  django, :primary => true

default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :deploy_via, :remote_cache
set :git_enable_submodules, 1

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && bundle exec whenever --update-crontab #{application}"
  end
end

task :copy_production_configurations do
  %w{database github}.each do |c|
    run "cp #{shared_path}/config/#{c}.yml #{release_path}/config/#{c}.yml"
  end
end

task :remove_config_ru do
  run "rm -f #{release_path}/config.ru"
end

after "deploy:update_code", :copy_production_configurations
after :copy_production_configurations, :remove_config_ru
#after :remove_config_ru, "deploy:update_crontab"
