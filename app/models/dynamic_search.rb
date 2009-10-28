# == Schema Information
# Schema version: 20091028135447
#
# Table name: dynamic_searches
#
#  id              :integer(4)      not null, primary key
#  resource_id     :integer(4)      
#  name            :string(255)     
#  target_klass_id :integer(4)      
#  target_meta_id  :integer(4)      
#  key_meta_id     :integer(4)      
#  op              :string(255)     
#  value_meta_id   :integer(4)      
#  value           :string(255)     
#  position        :integer(4)      
#  readonly        :boolean(1)      
#  created_at      :datetime        
#  updated_at      :datetime        
#

class DynamicSearch < ActiveRecord::Base

  belongs_to :target_meta, :class_name => 'Meta'
  belongs_to :target_klass, :class_name => 'Klass'
  belongs_to :key_meta, :class_name => 'Meta'
  belongs_to :value_meta, :class_name => 'Meta'

end
