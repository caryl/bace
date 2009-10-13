namespace :bace do
  desc "同步数据."
  task :install do
    system "rsync -ruv vendor/plugins/rbace/asset/db/migrate db"
    system "rsync -ruv vendor/plugins/rbace/asset/public ."
  end

  desc "同步vendor"
  task :install_vendor do
    system "rsync -ruv vendor/plugins/rbace/asset/vendor ."
  end
end