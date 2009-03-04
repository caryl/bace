namespace :bace do
  desc "rebuild resources to table"
  task :rebuild_resources => :environment do
    Resource.rebuild!
  end
end