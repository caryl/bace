namespace :bace do
  desc "rebuild resources to table"
  task :rebuild_resources => :environment do
    Resource.rebuild!
  end

  desc "rebuild klasses to table"
  task :rebuild_klasses => :environment do
    Klass.rebuild!
  end

end