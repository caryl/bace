class Menu < ActiveRecord::Base
  attr_accessor :visible
  acts_as_nested_set
  belongs_to :permission

  def to_html
    html = "#{'__'*self.level}#{self.name}"
    html = "<a href='#{self.url}'>#{html}</a>" if self.url.present?
    html
  end
end
