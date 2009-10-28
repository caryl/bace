#此文件作为engine时无用
ActionController::Base.send :include, BaceController
ActiveRecord::Base.send :include , BaceModel