namespace :bace do
  desc "同步数据."
  task :install do
    system "rsync -ruv vendor/plugins/bace/db/migrate db"
    system "rsync -ruv vendor/plugins/bace/public ."
  end

  desc "同步vendor"
  task :install_vendor do
    system "rsync -ruv vendor/plugins/bace/vendor ."
  end
end