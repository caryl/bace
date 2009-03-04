class Resource < ActiveRecord::Base

  belongs_to :permission

  def self.rebuild!
    files = Dir["#{Rails.root}/app/**/*controller.rb"]
    files.each {|f|require f}
    resources = []
    excludes = [] #maybe need exclude some module
    ApplicationController.subclasses.each do |controller_name|
      controller = controller_name.constantize
      actions = controller.action_methods.to_a - ApplicationController.action_methods.to_a
      excludes.each do |exclude|
        actions -= exclude.instance_methods if controller.is_a? exclude
      end
      actions.each do |action|
        resources << Resource.find_or_create_by_controller_and_action(controller.controller_name, action)
      end
    end
    (Resource.all - resources).each {|resource| resource.destroy}
  end
end
