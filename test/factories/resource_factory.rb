Factory.define :resource do |resource|
  resource.controller 'users'
  resource.action 'index'
  resource.permission_id '1'
end