class PermissionsMeta < ActiveRecord::Base
  belongs_to :permission
  belongs_to :meta

  #TODO:保存时默认target为 meta.klass.class.name
  #如果klass 为 * 表示可以对任何可能的类的查询(respond_to)生效
end
