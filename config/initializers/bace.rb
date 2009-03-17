#插入自定义查询条件
ActiveRecord::Base.send :include , BaceScope

#定义一个unlimit_find(*args)方法
module ActiveRecord
  class Base
    def self.unlimit_find(*args)
      if self.respond_to?(:find_with_bace)
        find_without_bace(*args)
      else
        find(*args)
      end
    end
  end
end
