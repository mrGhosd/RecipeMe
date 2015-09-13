# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'RecipeMe'
set :repo_url, 'git@github.com:mrGhosd/RecipeMe.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/recipeme"
set :deploy_user, 'deploy'
set :npm_target_path, -> { release_path.join('realtime') } # default not set
set :linked_files, %w{config/database.yml .env}

set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_shell, '/bin/bash -l'
# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end
  after :publishing, :restart

  desc "Rebuild thinking sphinx index"
  task :run_thinking_sphinx do
    on roles(:app), in: :sequence, wait: 5 do
      execute 'cd /home/deploy/recipeme/current && RAILS_ENV=production rake ts:index'
    end
  end

  desc "Run sidekiq ts delta workers"
  task :run_ts_deltas do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd /home/deploy/recipeme/current && bundle exec sidekiq -d -L log/sidekiq.log -C config/sidekiq.yml -e production -q ts_delta"
    end
  end

  task :run_nodejs_server do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'pm2:restart'
      # execute "cd /home/deploy/recipeme/current/realtime && forever start server.js"
    end
  end
  # after :restart, :run_thinking_sphinx
  # after :run_thinking_sphinx, :run_ts_deltas
  after :publishing, :run_nodejs_server

end
