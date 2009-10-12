namespace :bace do
  desc "同步数据."
  task :sync do
    system "rsync -ruv vendor/plugins/rbace/asset/db/migrate db"
    system "rsync -ruv vendor/plugins/rbace/asset/public ."
  end
end