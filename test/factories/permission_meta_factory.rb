Factory.define :permission_meta do |permission_meta|
  permission_meta.permission_id '1'
  permission_meta.meta_id '1'
  permission_meta.include 'MyString'
  permission_meta.joins 'MyString'
end
