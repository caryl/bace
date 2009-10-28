#此文件作为engine时无用
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # :secret => 'f6f1b454c715150aeb2da533584e9463'
end
