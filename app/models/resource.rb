# == Schema Information
# Schema version: 20091028135447
#
# Table name: resources
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)     
#  controller    :string(255)     
#  action        :string(255)     
#  permission_id :integer(4)      
#  created_at    :datetime        
#  updated_at    :datetime        
#

class Resource < ActiveRecord::Base
  belongs_to :permission

  def public?
    "#{self.controller}_controller".classify.constantize.always_public?(self.action)
  end

  def free?
    "#{self.controller}_controller".classify.constantize.always_free?(self.action)
  end

  def self.current
    self.unlimit_find(:first, :conditions => {:controller => Current.controller_name, :action => Current.action_name})
  end

  def before_create
    self.name ||= "#{self.action}_#{self.controller}"
  end

  def self.rebuild!
    files = Dir["#{Rails.root}/app/**/*controller.rb"]
    files |= Dir[File.join(File.dirname(__FILE__), '..', '**/*controller.rb')]
    files.each {|f|require f}
    resources = []
    excludes = [] #maybe need exclude some module
    ApplicationController.subclasses.each do |controller_name|
      controller = controller_name.constantize
      actions = controller.action_methods.to_a - ApplicationController.action_methods.to_a
      excludes.each do |exclude|
        actions -= exclude.instance_methods if controller.include? exclude
      end
      actions.each do |action|
        resources << Resource.find_or_create_by_controller_and_action(controller.controller_name, action)
      end
    end
    (Resource.all - resources).each {|resource| resource.destroy}
  end
end
