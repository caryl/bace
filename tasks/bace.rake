namespace :bace do
  desc "rebuild resources to table"
  task :rebuild_resources => :environment do
    Resource.rebuild!
  end

  desc "rebuild klasses to table"
  task :rebuild_klasses => :environment do
    Klass.rebuild!
  end

  desc "rebuild metas to table"
  task :rebuild_metas => :environment do
    Meta.rebuild!
  end

  desc "build permission scaffold"
  task :generate_permission => :environment do
    name, controller = ENV['name'], ENV['controller'], 
    parent = Permission.find_by_name(ENV['parent'])
    if name.blank? || controller.blank? || parent.blank?
      puts "usage: rake bace:generate_permission name=名称 controller=controller_name parent='上级" and return
    end
    permission = Permission.find_by_name(name) || Permission.create(:name => name, :parent => parent)

    dicts = [['查看',['index', 'show']],['新建',['new', 'create']],['修改',['edit', 'update']],['删除',['destroy']]]
    dicts.each do |d|
      p = Permission.find_by_name("#{d.first}#{name}") || Permission.create(:name => "#{d.first}#{name}", :parent => permission)
      d.last.each do |action|
        r = Resource.find_by_controller_and_action(controller, action)
        p.resources << r unless r.permission_id
      end
    end
  end
end