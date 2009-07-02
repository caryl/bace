# == Schema Information
# Schema version: 20090702173749
#
# Table name: menus
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)     
#  permission_id :integer(4)      
#  parent_id     :integer(4)      
#  lft           :integer(4)      
#  rgt           :integer(4)      
#  icon          :string(255)     
#  url           :string(255)     
#  remark        :string(255)     
#  created_at    :datetime        
#  updated_at    :datetime        
#

class Menu < ActiveRecord::Base
  attr_accessor :visible
  acts_as_nested_set
  belongs_to :permission

  def to_html
    html = "#{'&nbsp;&nbsp;'*self.level}#{self.name}"
    html = "<a href='#{self.url}'>#{html}</a>" if self.url.present?
    html
  end
end
