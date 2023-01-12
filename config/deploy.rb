# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"

set :application, "qna"
set :repo_url, "git@github.com:Mr-Slavka/qna.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :deploy_to, "/home/slavka/qna"
set :deploy_user, "slavka"
set :pty, false

set :rvm1_map_bins, %w{rake gem bundle ruby}




# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/master.key"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system",
       "vendor", "storage", "node_modules", "public/packs"

before "deploy:assets:precompile", "deploy:yarn_install"
namespace :deploy do
  desc "Run rake yarn install"
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install --silent --no-progress --no-audit --no-optional")
      end
    end
  end
end