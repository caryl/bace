Factory.define :permissions_meta do |permissions_meta|
  permissions_meta.target 'User'
  permissions_meta.permission_id '1'
  permissions_meta.meta_id '1'
  permissions_meta.include 'MyString'
  permissions_meta.joins 'MyString'
end
